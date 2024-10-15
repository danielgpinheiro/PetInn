defmodule PetInn.Repo.Migrations.CreateRatings do
  use Ecto.Migration

  def change do
    create table(:ratings, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :booking_id, :string
      add :inn_id, :string
      add :rating, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
