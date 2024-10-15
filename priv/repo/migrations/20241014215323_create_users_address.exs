defmodule PetInn.Repo.Migrations.CreateUsersAddress do
  use Ecto.Migration

  def change do
    create table(:users_address, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, :string
      add :country, :string
      add :state, :string
      add :city, :string
      add :neighborhood, :string
      add :street, :string
      add :number, :string
      add :complement, :string
      add :code, :string

      timestamps(type: :utc_datetime)
    end
  end
end
