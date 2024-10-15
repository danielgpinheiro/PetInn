defmodule PetInn.Repo.Migrations.CreatePetsMedicines do
  use Ecto.Migration

  def change do
    create table(:pets_medicines, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :pet_id, :string
      add :name, :string
      add :hours, {:array, :string}

      timestamps(type: :utc_datetime)
    end
  end
end
