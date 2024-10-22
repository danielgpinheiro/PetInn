defmodule PetInnWeb.CheckinController do
  use PetInnWeb, :controller

  alias PetInn.Inn
  alias PetInn.User

  def get_inn(inn_id) do
    case Inn.Methods.get_by_id(inn_id) do
      {:ok, value} -> :inn |> create_or_load_table_cache() |> :ets.insert({inn_id, value})
      {:error, _} -> nil
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
end
