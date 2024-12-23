defmodule PetInnWeb.BookingController do
  use PetInnWeb, :controller

  alias PetInn.Booking
  alias PetInn.Inn
  alias PetInnWeb.Utils.EtsUtils

  def create_booking(params) do
    case Booking.Methods.create_booking(params) do
      {:error, error} -> {:error, error}
      {:ok, _} -> {:ok}
    end
  end

  def get_full_booked_days_reservations(inn_id) do
    {:ok, %{max_supported_pets: inn_max_pets}} = Inn.Methods.get_by_id(inn_id)
    {:ok, date_to_filter_bookings} = Timex.format(Timex.today(), "{YYYY}-{0M}")
    {:ok, current_month} = Timex.format(Timex.today(), "{0M}")
    {:ok, current_year} = Timex.format(Timex.today(), "{YYYY}")

    bookings = Booking.Methods.get_bookings_by_start_date(%{date: date_to_filter_bookings, inn_id: inn_id})

    day_of_months = [
      {"01", 31},
      {"02", 28},
      {"03", 31},
      {"04", 30},
      {"05", 31},
      {"06", 30},
      {"07", 31},
      {"08", 31},
      {"09", 30},
      {"10", 31},
      {"11", 30},
      {"12", 31}
    ]

    {_, day_of_current_month} = Enum.find(day_of_months, fn tuple -> current_month === elem(tuple, 0) end)

    calendar_of_month =
      Enum.map(1..day_of_current_month, fn day ->
        %{day: day, pets: 0}
      end)

    last_day_in_calendar_of_month = calendar_of_month |> Enum.take(-1) |> Enum.at(0) |> Map.get(:day)

    calendar_ref = to_string(:erlang.ref_to_list(:erlang.make_ref()))

    :calendar |> EtsUtils.create_or_load_table_cache() |> :ets.insert({calendar_ref, calendar_of_month})

    Enum.each(bookings, fn booking ->
      start_date = NaiveDateTime.from_iso8601!(booking.start)
      end_date = NaiveDateTime.from_iso8601!(Map.get(booking, :end))
      days_between_start_and_end = Timex.diff(end_date, start_date, :days)

      {_, start_date_day} = Timex.format(start_date, "{D}")

      Enum.each(
        String.to_integer(start_date_day)..(String.to_integer(start_date_day) + days_between_start_and_end),
        fn day ->
          if(day in 1..last_day_in_calendar_of_month) do
            day_of_calendar =
              Enum.find(EtsUtils.get_table_cache(:calendar, calendar_ref), fn day_in_calendar ->
                day_in_calendar.day === day
              end)

            day_of_calendar_index =
              Enum.find_index(EtsUtils.get_table_cache(:calendar, calendar_ref), fn day_in_calendar ->
                day_in_calendar.day === day
              end)

            pets_amount_that_day = length(booking.pet_id) + day_of_calendar.pets

            new_day_of_calendar = Map.replace(day_of_calendar, :pets, pets_amount_that_day)

            new_list =
              List.replace_at(
                EtsUtils.get_table_cache(:calendar, calendar_ref),
                day_of_calendar_index,
                new_day_of_calendar
              )

            :calendar |> EtsUtils.create_or_load_table_cache() |> :ets.insert({calendar_ref, new_list})
          end
        end
      )
    end)

    booked_days =
      :calendar
      |> EtsUtils.get_table_cache(calendar_ref)
      |> Enum.filter(fn day -> day.pets >= inn_max_pets end)
      |> Enum.map(fn full_day ->
        current_year <> "-" <> current_month <> "-" <> Integer.to_string(full_day.day)
      end)

    :ets.delete(:calendar, calendar_ref)

    booked_days
  end
end
