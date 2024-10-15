defmodule PetInn.Inn.Methods do
  alias PetInn.Repo
  alias PetInn.Inn.Inn

  def get_by_id(inn_id) do
    case Repo.get_by(Inn, id: inn_id) do
      nil -> {:error, :not_found}
      values -> {:ok, values}
    end
  end
end
