defmodule PetInn.Pet.Medicine do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "pets_medicines" do
    field :name, :string
    field :hours, :string
    field :pet_id, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(medicine \\ %__MODULE__{}, attrs) do
    medicine
    |> cast(attrs, [:pet_id, :name, :hours])
    |> validate_required([:name, :hours, :pet_id])
  end
end
