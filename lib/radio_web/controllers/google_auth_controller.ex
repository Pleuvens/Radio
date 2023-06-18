defmodule RadioWeb.GoogleAuthController do
  use Phoenix.Controller,
    formats: [:html, :json],
    layouts: [html: RadioWeb.Layouts]

  @doc """
  `index/2` handles the callback from Google Auth API redirect.
  """
  def index(conn, %{"code" => code}) do
    {:ok, token} = ElixirAuthGoogle.get_token(code, RadioWeb.Endpoint.url())
    {:ok, profile} = ElixirAuthGoogle.get_user_profile(token.access_token)
    render(conn, :welcome, profile: profile)
  end
end
