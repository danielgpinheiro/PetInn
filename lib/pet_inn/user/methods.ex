defmodule PetInn.User.Methods do
  @moduledoc false
  import Ecto.Query

  alias PetInn.Repo
  alias PetInn.User
  alias PetInn.User.Address

  def get_by_email_and_phone(params) do
    case User
         |> where(email: ^params.email)
         |> where(phone: ^params.phone)
         |> Repo.one() do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  def get_address_by_user_id(user_id) do
    case Address |> where(user_id: ^user_id) |> Repo.one() do
      nil -> {:error, :not_found}
      address -> {:ok, address}
    end
  end

  def create_user(params) do
    params
    |> User.changeset(User)
    |> Repo.insert()
  end
end
