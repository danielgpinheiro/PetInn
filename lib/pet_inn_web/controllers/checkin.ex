defmodule PetInnWeb.CheckinController do
  use PetInnWeb, :controller

  alias PetInn.Inn

  def get_inn(inn_id) do
    case Inn.Methods.get_by_id(inn_id) do
      {:ok, value} -> create_inn_cache() |> :ets.insert({inn_id, value})
      {:error, _} -> nil
    end
  end

  def create_inn_cache() do
    if Enum.member?(:ets.all(), :inn) == false do
      :ets.new(:inn, [:public, :named_table])
    else
      :ets.whereis(:inn)
    end
  end

  def create_user_cache() do
    if Enum.member?(:ets.all(), :user) == false do
      :ets.new(:user, [:public, :named_table])
    else
      :ets.whereis(:user)
    end
  end

  def get_table_cache(name, id) do
    Enum.at(:ets.lookup(name, id), 0) |> elem(1)
  end
end
