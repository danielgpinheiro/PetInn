defmodule PetInn.Pet.Methods do
  @moduledoc false
  import Ecto.Query

  alias PetInn.Pet
  alias PetInn.Repo

  def get_by_user_id(user_id) do
    case Pet
         |> where(user_id: ^user_id)
         |> Repo.all() do
      nil -> {:error, :not_found}
      pets -> {:ok, pets}
    end
  end
end
