defmodule PetInn.Pet.Methods do
  @moduledoc false
  import Ecto.Query

  alias PetInn.Pet
  alias PetInn.Pet.Medicine
  alias PetInn.Repo

  def get_by_user_id(user_id) do
    case Pet
         |> where(user_id: ^user_id)
         |> Repo.all() do
      nil -> {:error, :not_found}
      pets -> {:ok, pets}
    end
  end

  def get_medicines_by_pet_id(pet_id) do
    case Medicine
         |> where(pet_id: ^pet_id)
         |> Repo.all() do
      nil -> {:error, :not_found}
      medicines -> {:ok, medicines}
    end
  end
end
