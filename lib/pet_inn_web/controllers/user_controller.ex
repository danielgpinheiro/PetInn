defmodule PetInnWeb.UserController do
  use PetInnWeb, :controller

  alias PetInn.User
  alias PetInnWeb.PetController
  alias PetInnWeb.Utils.EtsUtils

  def get_by_user_id(user_id) do
    case User.Methods.get_by_user_id(user_id) do
      {:ok, value} ->
        value

      {:error, _} ->
        nil
    end
  end

  def create_or_load_user(params) do
    case User.Methods.get_by_email_and_phone(params) do
      {:error, :not_found} ->
        :user |> EtsUtils.create_or_load_table_cache() |> :ets.insert({params.email, params})

      {:ok, values} ->
        :user |> EtsUtils.create_or_load_table_cache() |> :ets.insert({values.email, Map.from_struct(values)})
    end
  end

  def update_user(params) do
    :user |> EtsUtils.create_or_load_table_cache() |> :ets.insert({params.email, params})
  end

  def get_user_address(user_id) do
    case User.Methods.get_address_by_user_id(user_id) do
      {:ok, values} ->
        values

      {:error, :not_found} ->
        {:not_found}
    end
  end

  def save_user(params) do
    user_values = %{
      name: params.name,
      email: params.email,
      phone: params.phone,
      birthday: params.birthday,
      gender: params.gender,
      job: params.job
    }

    saved_user =
      case Map.get(params, :id) do
        nil ->
          User.Methods.create_user(user_values)

        _ ->
          {_, user} = User.Methods.get_by_user_id(params.id)
          User.Methods.update_user(user, user_values)
      end

    case saved_user do
      {:error, _} -> saved_user
      {:ok, values} -> save_user_address(Map.put(params, :id, values.id))
    end
  end

  def save_user_address(params) do
    user_id = params.id

    address_values = %{
      user_id: user_id,
      country: params.address.country,
      state: params.address.state,
      city: params.address.city,
      neighborhood: params.address.neighborhood,
      street: params.address.street,
      number: params.address.number,
      complement: params.address.complement,
      code: params.address.code
    }

    saved_address =
      case get_user_address(user_id) do
        {:not_found} ->
          User.Methods.create_address(address_values)

        values ->
          User.Methods.update_addres(values, address_values)
      end

    case saved_address do
      {:error, _} -> saved_address
      {:ok, _} -> PetController.save_pets(params)
    end
  end
end
