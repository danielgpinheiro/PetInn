defmodule PetInnWeb.Utils.EtsUtils do
  @moduledoc false
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
end
