defmodule PetInnWeb.Shared.Checkin.Steps.Pet.MedicineFormSchema do
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
