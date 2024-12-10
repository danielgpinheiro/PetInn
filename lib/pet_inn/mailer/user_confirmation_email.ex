defmodule PetInn.Mailer.UserConfirmationEmail do
  @moduledoc false
  import Swoosh.Email

  def confirmation(user, inn) do
    new()
    |> from({"no-reply", "no-reply@petinns.com.br"})
    |> to({user.name, user.email})
    |> put_provider_option(:template_id, 2)
    |> put_provider_option(:params, %{
      name: user.name,
      inn: inn.name,
      url: "http://localhost:4000/confirmation/" <> inn.id <> "/" <> user.id
    })
  end
end
