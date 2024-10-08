defmodule PetInn.Repo do
  use Ecto.Repo,
    otp_app: :pet_inn,
    adapter: Ecto.Adapters.Postgres
end
