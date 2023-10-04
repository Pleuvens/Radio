defmodule RadioPlayer do
  use GenServer

  def start_link(playlist_id) do
    name = via_tuple(playlist_id)
    GenServer.start_link(__MODULE__, playlist_id, name: name)
  end

  defp via_tuple(playlist_id) do
    {:via, Registry, {:radio_player_registry, playlist_id}}
  end

  defp play_song(playlist_id, song, time) do
    IO.inspect("Now playing #{song.name} at #{time} seconds")

    Phoenix.PubSub.broadcast(
      Radio.PubSub,
      "radio_player#{playlist_id}",
      {:play_next_song, %{song: song, time: time}}
    )
  end

  def get_current_song(playlist_id) do
    GenServer.call(via_tuple(playlist_id), :get_current_song)
  end

  @impl true
  def init(playlist_name) do
    Utils.init_db(playlist_name)

    [p] = Playlist.API.get(playlist_name)

    state = %{
      name: playlist_name,
      songs: p.songs || [],
      current_song: 0,
      s_played: 0
    }

    play_song(state.name, Enum.at(state.songs, state.current_song), state.s_played)
    Process.send_after(self(), :timeout, 1000)
    {:ok, state}
  end

  @impl true
  def handle_call(:get_current_song, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_info(:timeout, state) do
    new_elapsed_time = state.s_played + 1
    song = Enum.at(state.songs, state.current_song)

    if song.duration - new_elapsed_time > 0 do
      Process.send_after(self(), :timeout, 1000)
      {:noreply, %{state | s_played: new_elapsed_time}}
    else
      next_song =
        cond do
          state.current_song + 1 >= length(state.songs) -> 0
          true -> state.current_song + 1
        end

      play_song(state.name, Enum.at(state.songs, next_song), 0)
      Process.send_after(self(), :timeout, 1000)
      {:noreply, %{state | current_song: next_song, s_played: 0}}
    end
  end
end
