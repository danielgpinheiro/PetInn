defmodule PetInn.Pet do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "pets" do
    field :name, :string
    field :user_id, :string
    field :specie, :string
    field :race, :string
    field :photo, :string
    field :food_hours, {:array, :string}
    field :is_natural_food, :boolean, default: false
    field :vaccination_card, :string
    field :notes_about_pet, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(pet, attrs) do
    pet
    |> cast(attrs, [
      :user_id,
      :name,
      :specie,
      :race,
      :photo,
      :food_hours,
      :is_natural_food,
      :vaccination_card,
      :notes_about_pet
    ])
    |> validate_required([
      :user_id,
      :name,
      :specie,
      :race,
      :photo,
      :food_hours,
      :is_natural_food,
      :vaccination_card,
      :notes_about_pet
    ])
  end
end
