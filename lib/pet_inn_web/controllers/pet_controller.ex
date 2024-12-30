defmodule PetInnWeb.PetController do
  use PetInnWeb, :controller

  alias PetInn.Pet

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
       else: {:ok, user_id}
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
