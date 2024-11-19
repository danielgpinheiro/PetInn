defmodule PetInnWeb.CheckinController do
  use PetInnWeb, :controller

  alias PetInn.Inn
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
end
