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

  def get_by_user_id(user_id) do
    case Repo.get_by(User, id: user_id) do
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
    |> User.changeset()
    |> Repo.insert()
  end

  def update_user(user, params) do
    user
    |> User.changeset(params)
    |> Repo.update()
  end

  def create_address(params) do
    params |> Address.changeset() |> Repo.insert()
  end

  def update_addres(address, params) do
    address
    |> Address.changeset(params)
    |> Repo.update()
  end
end
