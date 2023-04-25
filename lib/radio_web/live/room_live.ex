defmodule Radio.RoomLive do
  use RadioWeb, :live_view

  def mount(%{"playlist_id" => playlist_id}, _token, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, 1000)

    {song, time} = RadioPlayer.get_current_song(playlist_id)
    {:ok, assign(socket, player: %{name: playlist_id, song: song, time: time})}
  end

  def handle_info(:update, socket) do
    Process.send_after(self(), :update, 1000)

    {song, time} = RadioPlayer.get_current_song(socket.assigns.player.nam)

    cond do
      song.id == socket.assigns.player.song.id ->
        {:noreply, assign(socket, player: %{name: socket.assigns.player.name, song: socket.assigns.player.song, time: time})}
      true ->
        {:noreply, assign(socket, player: %{name: socket.assigns.player.name, song: song, time: time})}
    end
  end
end
