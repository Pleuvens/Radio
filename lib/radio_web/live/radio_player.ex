defmodule RadioWeb.RadioPlayer do
  use RadioWeb, :live_view

  @topic "radio_player"

  def mount(_params, _token, socket) do
    playlist_id = "test"
    if connected?(socket), do: Phoenix.PubSub.subscribe(Radio.PubSub, @topic <> playlist_id)
    RadioPlayer.start_link(playlist_id)
    {:ok, assign(socket, %{})}
  end

  def handle_info(params, socket) do
    IO.inspect(params, label: "handle_info params")
    {:noreply, push_event(socket, "start-player", %{song: params.song, time: params.time})}
  end

  def handle_event("start_player", _params, socket) do
    r = RadioPlayer.get_current_song("test")
    {:noreply, push_event(socket, "start-player", %{song: Enum.at(r.songs, r.current_song), time: r.s_played})}
  end
end
