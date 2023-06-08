defmodule RadioPlayer do
  use GenServer
  import Ecto.Query

  def init_db do
    query = from p in Playlist, where: p.name == "test"
    if !Radio.Repo.exists?(query) do
      {_, p} = Playlist.API.put("test")
      Song.API.put("Entre 4 murs", "Bekar", 154, "/api/song/Bekar - Entre 4 murs (clip officiel).mp3", 1, p)
      Song.API.put("Présidentiel flow", "H JeuneCrack", 161, "/api/song/H JeuneCrack - Présidentiel flow.mp3", 2, p)
    end
  end

  def start_link(playlist_id) do
    name = via_tuple(playlist_id)
    GenServer.start_link(__MODULE__, playlist_id, name: name)
  end

  defp via_tuple(playlist_id) do
    {:via, Registry, {:radio_player_registry, playlist_id}}
  end

  defp play_song(song, time) do
    IO.inspect("Now playing #{song.name} at #{time} seconds")
    Phoenix.PubSub.broadcast(Radio.PubSub, "radio_playertest", %{song: song, time: time})
  end

  def get_current_song(playlist_id) do
    GenServer.call(via_tuple(playlist_id), :get_current_song)
  end

  @impl true
  def init(playlist_name) do
    init_db()

    [p] = Playlist.API.get(playlist_name)
    state = %{
      songs: p.songs || [],
      current_song: 0,
      s_played: 0
    }

    play_song(Enum.at(state.songs, state.current_song), state.s_played)
    {:ok, state, 1000}
  end

  @impl true
  def handle_call(:get_current_song, _from, state) do
    {:reply, state, state, 10}
  end

  @impl true
  def handle_info(:timeout, state) do
    new_elapsed_time = state.s_played + 1
    song = Enum.at(state.songs, state.current_song)
    if song.duration - new_elapsed_time > 0 do
      {:noreply, %{state | s_played: new_elapsed_time}, 1000}
    else
      next_song = cond do
        state.current_song + 1 >= length(state.songs) -> 0
        true -> state.current_song + 1
      end

      play_song(Enum.at(state.songs, next_song), 0)
      {:noreply, %{state | current_song: next_song, s_played: 0}, 1000}
    end
  end
end
