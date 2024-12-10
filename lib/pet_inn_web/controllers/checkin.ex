defmodule PetInnWeb.CheckinController do
  use PetInnWeb, :controller

  alias PetInn.Inn
  alias PetInn.Mailer
  alias PetInn.Pet
  alias PetInn.User

  def get_inn(inn_id) do
    case Inn.Methods.get_by_id(inn_id) do
      {:ok, value} ->
        value

      {:error, _} ->
        nil
    end
  end

  def update_user(params) do
    :user |> create_or_load_table_cache() |> :ets.insert({params.email, params})
  end

  def get_table_cache(name, id) do
    name |> :ets.lookup(id) |> Enum.at(0) |> elem(1)
  end

  def create_or_load_table_cache(name) do
    if Enum.member?(:ets.all(), name) == false do
      :ets.new(name, [:public, :set, :named_table])
    else
      :ets.whereis(name)
    end
  end

  def create_or_load_user(params) do
    case User.Methods.get_by_email_and_phone(params) do
      {:error, :not_found} ->
        :user |> create_or_load_table_cache() |> :ets.insert({params.email, params})

      {:ok, values} ->
        :user |> create_or_load_table_cache() |> :ets.insert({values.email, Map.from_struct(values)})
    end
  end

  def get_pets(user_id) do
    case Pet.Methods.get_by_user_id(user_id) do
      {:ok, []} ->
        {:not_found}

      {:ok, pets} ->
        Enum.map(pets, fn pet ->
          Map.put(pet, :medicines, get_pets_medicines(pet.id))
        end)

      {:error, :not_found} ->
        {:not_found}
    end
  end

  def get_pets_medicines(pet_id) do
    case Pet.Methods.get_medicines_by_pet_id(pet_id) do
      {:ok, []} ->
        {:not_found}

      {:ok, values} ->
        values

      {:error, :not_found} ->
        {:not_found}
    end
  end

  def get_user_address(user_id) do
    case User.Methods.get_address_by_user_id(user_id) do
      {:ok, values} ->
        values

      {:error, :not_found} ->
        {:not_found}
    end
  end

  def send_confirmation_email(user, inn) do
    case user |> Mailer.UserConfirmationEmail.confirmation(inn) |> Mailer.Adapter.deliver() do
      {:ok, _} -> {:ok}
      {_, _} -> {:error}
    end
  end

  def save_user(params) do
    user_values = %{
      name: params.name,
      email: params.email,
      phone: params.phone,
      birthday: params.birthday,
      gender: params.gender,
      job: params.job
    }

    saved_user =
      case Map.get(params, :id) do
        nil ->
          User.Methods.create_user(user_values)

        _ ->
          {_, user} = User.Methods.get_by_user_id(params.id)
          User.Methods.update_user(user, user_values)
      end

    case saved_user do
      {:error, _} -> saved_user
      {:ok, values} -> save_user_address(Map.put(params, :id, values.id))
    end
  end

  def save_user_address(params) do
    user_id = params.id

    address_values = %{
      user_id: user_id,
      country: params.address.country,
      state: params.address.state,
      city: params.address.city,
      neighborhood: params.address.neighborhood,
      street: params.address.street,
      number: params.address.number,
      complement: params.address.complement,
      code: params.address.code
    }

    saved_address =
      case get_user_address(user_id) do
        {:not_found} ->
          User.Methods.create_address(address_values)

        values ->
          User.Methods.update_addres(values, address_values)
      end

    case saved_address do
      {:error, _} -> saved_address
      {:ok, _} -> save_pets(params)
    end
  end

  def save_pets(params) do
    user_id = params.id

    case Pet.Methods.get_by_user_id(user_id) do
      {:ok, previous_pets} ->
        Enum.map(previous_pets, fn previous_pet -> Pet.Methods.delete_all_medicines_by_pet_id(previous_pet.id) end)

      {:error, _} ->
        nil
    end

    Pet.Methods.delete_all_pets_by_user_id(user_id)

    saved_pets =
      Enum.map(params.pets, fn pet ->
        handle_pet_food_hours(pet.food_hours)

        new_pet_created =
          Pet.Methods.create_pet(%{
            user_id: user_id,
            name: pet.name,
            specie: pet.specie,
            race: pet.race,
            is_natural_food: pet.is_natural_food,
            notes: pet.notes,
            photo: pet.photo,
            vaccination_card: pet.vaccination_card,
            food_hours: handle_pet_food_hours(pet.food_hours)
          })

        case new_pet_created do
          {:error, _} -> new_pet_created
          {:ok, values} -> handle_pet_medicinies(%{pet_id: values.id, medicines: pet.medicines})
        end
      end)

    if length(
         Enum.filter(saved_pets, fn y ->
           elem(y, 0) === :error
         end)
       ) > 0,
       do: {:error},
       else: {:ok}
  end

  defp handle_pet_medicinies(params) do
    pet_id = params.pet_id

    saved_medicines =
      params.medicines
      |> Enum.filter(fn x -> x.name !== nil and x.hours !== nil end)
      |> Enum.map(fn medicine ->
        Pet.Methods.create_medicine(%{
          pet_id: pet_id,
          name: medicine.name,
          hours: medicine.hours
        })
      end)

    if length(
         Enum.filter(saved_medicines, fn y ->
           elem(y, 0) === :error
         end)
       ) > 0,
       do: {:error},
       else: {:ok}
  end

  defp handle_pet_food_hours(food_hours) do
    food_hours =
      food_hours
      |> Enum.map(fn food_hour ->
        food_hour.hour
      end)
      |> Enum.filter(fn x -> x end)

    case food_hours do
      [] -> nil
      _ -> food_hours
    end
  end
end
