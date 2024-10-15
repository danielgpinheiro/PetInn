defmodule PetInn.Repo.Migrations.CreateBookings do
  use Ecto.Migration

  def change do
    create table(:bookings, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :start, :string
      add :end, :string
      add :pet_id, {:array, :string}
      add :inn_id, :string

      timestamps(type: :utc_datetime)
    end
  end
end
