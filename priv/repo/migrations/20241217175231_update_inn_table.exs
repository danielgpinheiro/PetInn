defmodule PetInn.Repo.Migrations.UpdateInnTable do
  use Ecto.Migration

  def change do
    alter table(:inns) do
      add :max_supported_pets, :integer
    end
  end
end
