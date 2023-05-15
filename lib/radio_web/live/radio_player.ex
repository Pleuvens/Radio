defmodule RadioWeb.RadioPlayer do
  use RadioWeb, :live_view

  @topic "radio_player"

  def mount(_params, _token, socket) do
    playlist_id = "test"
    if connected?(socket), do: Phoenix.PubSub.subscribe(Radio.PubSub, @topic <> playlist_id)
    RadioPlayer.start_link(playlist_id)
    {:ok, assign(socket, player: %{song: ""})}
  end

  def handle_info(params, socket) do
    IO.inspect(params, label: "handle_info params")
    {:noreply, socket}
  end

  def handle_event("start_player", _params, socket) do
    r = RadioPlayer.start_player("test")
    {:noreply, assign(socket, player: %{song: Enum.at(r.songs, r.current_song)})}
  end
end
