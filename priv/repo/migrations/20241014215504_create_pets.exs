defmodule PetInn.Repo.Migrations.CreatePets do
  use Ecto.Migration

  def change do
    create table(:pets, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, :string
      add :name, :string
      add :specie, :string
      add :race, :string
      add :photo, :text
      add :food_hours, {:array, :string}
      add :is_natural_food, :boolean, default: false, null: false
      add :vaccination_card, :text
      add :notes_about_pet, :string

      timestamps(type: :utc_datetime)
    end
  end
end
