defmodule PetInn.User.Methods do
  alias PetInn.Repo
  alias PetInn.User

  import Ecto.Query

  def get_by_email_and_phone(params) do
    case User
         |> where(email: ^params.email)
         |> where(phone: ^params.phone)
         |> Repo.one() do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  def create_user(params) do
    params
    |> User.changeset(User)
    |> Repo.insert()
  end
end
