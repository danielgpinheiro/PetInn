defmodule PetInn.Repo.Migrations.CreateAdmins do
  use Ecto.Migration

  def change do
    create table(:admins, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string
      add :inn_id, :string

      timestamps(type: :utc_datetime)
    end
  end
end
