defmodule PetInn.Inn.Methods do
  @moduledoc false
  alias PetInn.Inn
  alias PetInn.Repo

  def get_by_id(inn_id) do
    case Repo.get_by(Inn, id: inn_id) do
      nil -> {:error, :not_found}
      values -> {:ok, values}
    end
  end
end
