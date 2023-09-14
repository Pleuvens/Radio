defmodule RadioPlayer do
  use GenServer
  import Ecto.Query

  def init_db do
    query = from p in Playlist, where: p.name == "test"
    if !Radio.Repo.exists?(query) do
      {_, p} = Playlist.API.put("test")
      Song.API.put("Entre 4 murs", "Bekar", 154, "https://lpradio-dev.s3.eu-west-3.amazonaws.com/Bekar+-+Entre+4+murs+(clip+officiel).mp3", 1, p)
      Song.API.put("Présidentiel flow", "H JeuneCrack", 161, "https://lpradio-dev.s3.eu-west-3.amazonaws.com/H+JeuneCrack+-+Pr%C3%A9sidentiel+flow.mp3", 2, p)
    end
  end

  def start_link(playlist_id) do
    name = via_tuple(Enum.at(playlist_id, 0))
    GenServer.start_link(__MODULE__, playlist_id, name: name)
  end

  defp via_tuple(playlist_id) do
    {:via, Registry, {:radio_player_registry, playlist_id}}
  end

  defp play_song(song, time) do
    IO.inspect("Now playing #{song.name} at #{time} seconds")
    Phoenix.PubSub.broadcast(Radio.PubSub, "radio_playertest", {:play_next_song, %{song: song, time: time}})
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
    Process.send_after(self(), :timeout, 1000)
    {:ok, IO.inspect(state, label: "RADIO PLAYER STARTED")}
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
      next_song = cond do
        state.current_song + 1 >= length(state.songs) -> 0
        true -> state.current_song + 1
      end

      play_song(Enum.at(state.songs, next_song), 0)
      Process.send_after(self(), :timeout, 1000)
      {:noreply, %{state | current_song: next_song, s_played: 0}}
    end
  end
end
