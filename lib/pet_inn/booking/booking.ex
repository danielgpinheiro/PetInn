defmodule PetInn.Booking do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "bookings" do
    field :start, :string
    field :end, :string
    field :pet_id, {:array, :string}
    field :inn_id, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(booking, attrs) do
    booking
    |> cast(attrs, [:start, :end, :pet_id, :inn_id])
    |> validate_required([:start, :end, :pet_id, :inn_id])
  end
end
