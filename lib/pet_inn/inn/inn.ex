defmodule PetInn.Inn do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "inns" do
    field :name, :string
    field :address, :string
    field :logo, :string
    field :checkin_hour, :string
    field :checkout_hour, :string
    field :species_pet_allowed, {:array, :string}
    field :diary_price, :string
    field :maps_URL, :string
    field :max_supported_pets, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(inn, attrs) do
    inn
    |> cast(attrs, [
      :name,
      :logo,
      :checkin_hour,
      :checkout_hour,
      :species_pet_allowed,
      :diary_price,
      :address,
      :maps_URL,
      :max_supported_pets
    ])
    |> validate_required([
      :name,
      :logo,
      :checkin_hour,
      :checkout_hour,
      :species_pet_allowed,
      :diary_price,
      :address,
      :maps_URL,
      :max_supported_pets
    ])
  end
end
