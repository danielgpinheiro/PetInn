defmodule PetInn.Pet.FoodHourForm do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  schema "pets_food_hours_form" do
    field :hour, :string
  end

  def changeset(food_hours, attrs) do
    cast(food_hours, attrs, [:hour])
  end
end
