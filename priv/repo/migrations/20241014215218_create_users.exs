defmodule PetInn.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string
      add :phone, :string
      add :name, :string
      add :birthday, :string
      add :gender, :string
      add :job, :string

      timestamps(type: :utc_datetime)
    end
  end
end
