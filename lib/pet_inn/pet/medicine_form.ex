defmodule PetInn.Pet.MedicineForm do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  schema "pets_medicines_form" do
    field :name, :string
    field :hours, :string
  end

  @doc false
  def changeset(medicine, attrs) do
    cast(medicine, attrs, [:name, :hours])
  end
end
