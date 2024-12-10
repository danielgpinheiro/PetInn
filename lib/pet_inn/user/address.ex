defmodule PetInn.User.Address do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users_address" do
    field :code, :string
    field :state, :string
    field :number, :string
    field :user_id, :string
    field :country, :string
    field :city, :string
    field :neighborhood, :string
    field :street, :string
    field :complement, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(address \\ %__MODULE__{}, attrs) do
    address
    |> cast(attrs, [:user_id, :country, :state, :city, :neighborhood, :street, :number, :complement, :code])
    |> validate_required([:user_id, :country, :state, :city, :street, :number, :code])
  end
end
