defmodule PetInnWeb.CheckinController do
  use PetInnWeb, :controller

  alias PetInn.Inn
  alias PetInn.User

  def get_inn(inn_id) do
    case Inn.Methods.get_by_id(inn_id) do
      {:ok, value} -> create_table_cache(:inn) |> :ets.insert({inn_id, value})
      {:error, _} -> nil
    end
  end

  def update_user(params) do
    :ets.lookup(:user, params.email) |> :ets.insert(params)
  end

  def get_table_cache(name, id) do
    :ets.lookup(name, id) |> Enum.at(0) |> elem(1)
  end

  def create_table_cache(name) do
    if Enum.member?(:ets.all(), name) == false do
      :ets.new(name, [:public, :set, :named_table])
    else
      :ets.whereis(name)
    end
  end

  def create_or_load_user(params) do
    case User.Methods.get_by_email_and_phone(params) do
      {:error, :not_found} -> create_table_cache(:user) |> :ets.insert({params.email, params})
      {:ok, _} -> get_table_cache(:user, params.email)
    end
  end
end
