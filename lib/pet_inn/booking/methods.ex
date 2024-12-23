defmodule PetInn.Booking.Methods do
  @moduledoc false
  import Ecto.Query

  alias PetInn.Booking
  alias PetInn.Repo

  def create_booking(params) do
    params
    |> Booking.changeset()
    |> Repo.insert()
  end

  def get_bookings_by_start_date(params) do
    Booking
    |> where([p], like(p.start, ^"%#{String.replace(params.date, "%", "\\%")}%"))
    |> where(inn_id: ^params.inn_id)
    |> Repo.all()
  end
end
