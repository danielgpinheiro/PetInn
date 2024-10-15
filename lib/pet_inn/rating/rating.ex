defmodule PetInn.Rating do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "ratings" do
    field :booking_id, :string
    field :inn_id, :string
    field :rating, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(rating, attrs) do
    rating
    |> cast(attrs, [:booking_id, :inn_id, :rating])
    |> validate_required([:booking_id, :inn_id, :rating])
  end
end
