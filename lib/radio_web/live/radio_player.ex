defmodule RadioWeb.RadioPlayer do
  use RadioWeb, :live_view

  @topic "radio_player"

  def mount(_params, _token, socket) do
    playlist_id = "test"
    if connected?(socket), do: Phoenix.PubSub.subscribe(Radio.PubSub, @topic <> playlist_id)
    {:ok, assign(socket, %{})}
  end

  def handle_event("start_player", _params, socket) do
    r = RadioPlayer.get_current_song("test")
    {:noreply, push_event(socket, "start-player", %{song: Enum.at(r.songs, r.current_song), time: r.s_played})}
  end

  def handle_event("stop_player", _params, socket) do
    # TODO: user management system with rights on playlists
    #{:noreply, push_event(socket, "stop-player", %{})}
    {:noreply, socket}
  end

  def handle_info({:play_next_song, data}, socket) do
    {:noreply, push_event(socket, "start-player", %{song: data.song, time: data.time})}
  end
end
