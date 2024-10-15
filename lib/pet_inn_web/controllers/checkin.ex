defmodule PetInnWeb.CheckinController do
  use PetInnWeb, :controller

  alias PetInn.Inn

  def get_inn(inn_id) do
    case Inn.Methods.get_by_id(inn_id) do
      {:ok, value} -> create_table_cache(:inn) |> :ets.insert({inn_id, value})
      {:error, _} -> nil
    end
  end

  def get_table_cache(name, id) do
    :ets.lookup(name, id) |> Enum.at(0) |> elem(1)
  end

  def create_table_cache(name) do
     if Enum.member?(:ets.all(), name) == false do
      :ets.new(name, [:public, :named_table])
    else
      :ets.whereis(name)
    end
  end
end
