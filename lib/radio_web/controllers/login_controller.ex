defmodule RadioWeb.LoginController do
  use Phoenix.Controller,
    formats: [:html, :json],
    layouts: [html: RadioWeb.Layouts]

  def show(conn, _params) do
    base_url = RadioWeb.Endpoint.url()
    oauth_google_url = ElixirAuthGoogle.generate_oauth_url(base_url)
    render(conn, :home, oauth_google_url: oauth_google_url)
  end
end
