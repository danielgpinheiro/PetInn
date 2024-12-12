defmodule PetInnWeb.InnController do
  use PetInnWeb, :controller

  alias PetInn.Inn

  def get_inn(inn_id) do
    case Inn.Methods.get_by_id(inn_id) do
      {:ok, value} ->
        value

      {:error, _} ->
        nil
    end
  end
end
