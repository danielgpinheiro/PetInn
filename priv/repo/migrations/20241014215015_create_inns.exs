defmodule PetInn.Repo.Migrations.CreateInns do
  use Ecto.Migration

  def change do
    create table(:inns, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :logo, :text
      add :checkin_hour, :string
      add :checkout_hour, :string
      add :species_pet_allowed, {:array, :string}
      add :diary_price, :string
      add :address, :string
      add :maps_URL, :string

      timestamps(type: :utc_datetime)
    end
  end
end
