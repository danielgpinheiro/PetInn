defmodule PetInn.Pet.FoodHours do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  schema "food_hours" do
    field :hour, :string
  end

  def changeset(food_hours, attrs) do
    cast(food_hours, attrs, [:hour])
  end
end
