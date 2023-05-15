defmodule RadioPlayer do
  use GenServer

  def start_link(playlist_id) do
    name = via_tuple(playlist_id)
    GenServer.start_link(__MODULE__, playlist_id, name: name)
  end

  defp via_tuple(playlist_id) do
    {:via, Registry, {:radio_player_registry, playlist_id}}
  end

  defp play_song(song, time) do
    IO.inspect("Now playing #{song} at #{time} seconds")
  end

  def start_player(playlist_id, song \\ 0, time \\ 0) do
    GenServer.call(via_tuple(playlist_id), {:start, song, time})
  end

  @impl true
  def init(playlist_id) do
    state = %{
      songs: Playlist.API.get(playlist_id) || [],
      current_song: 0,
      s_played: 0
    }

    {:ok, state}
  end

  @impl true
  def handle_call({:start, song, time}, _from, state) do
    play_song(Enum.at(state.songs, song), time)
    new_state = %{state | current_song: song, s_played: time}
    {:reply, new_state, new_state}
  end
end
