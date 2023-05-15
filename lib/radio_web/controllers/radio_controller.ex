defmodule RadioWeb.RadioController do
  use RadioWeb, :controller

  def get_song(conn, %{"name" => name}) do
    path = "/home/fervil/Documents/radio/data/songs/#{name}" # Application.app_dir(:radio, "data/songs/#{name}")
    send_download(conn, {:file, path})
  end
end
