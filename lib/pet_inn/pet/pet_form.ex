defmodule PetInn.Pet.PetForm do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  alias PetInn.Pet.FoodHourForm
  alias PetInn.Pet.MedicineForm

  schema "pet_form" do
    field :name, :string
    field :specie, :string
    field :race, :string
    field :is_natural_food, :boolean, default: false
    field :notes, :string
    field :photo, :string
    field :vaccination_card, :string

    has_many :food_hours, FoodHourForm
    has_many :medicines, MedicineForm
  end

  def changeset(pet_form, attrs) do
    pet_form
    |> cast(attrs, [
      :name,
      :specie,
      :race,
      :is_natural_food,
      :notes,
      :photo,
      :vaccination_card
    ])
    |> validate_required(:name, message: "É necessário inserir um nome")
    |> validate_required(:specie, message: "É necessário selecionar uma espécie")
    |> validate_required(:race, message: "É necessário inserir um nome de raça")
    |> Ecto.Changeset.cast_assoc(:food_hours,
      required: false,
      with: &FoodHourForm.changeset/2
    )
    |> Ecto.Changeset.cast_assoc(:medicines, required: false, with: &MedicineForm.changeset/2)
  end
end
