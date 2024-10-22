defmodule PetInn.Pet.Medicine do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "pets_medicines" do
    field :name, :string
    field :hours, {:array, :string}
    field :pet_id, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(medicine, attrs) do
    medicine
    |> cast(attrs, [:pet_id, :name, :hours])
    |> validate_required([:pet_id, :name, :hours])
  end
end
