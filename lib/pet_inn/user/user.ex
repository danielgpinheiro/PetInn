defmodule PetInn.User do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :name, :string
    field :email, :string
    field :phone, :string
    field :birthday, :string
    field :gender, :string
    field :job, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :phone, :name, :birthday, :gender, :job])
    |> validate_required([:email, :phone, :name, :birthday, :gender, :job])
  end
end
