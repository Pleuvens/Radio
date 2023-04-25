defmodule RadioPlayer do
  use GenServer

  defp schedule_update do
    Process.send_after(self(), :time, 500)
  end

  def get_current_song(id) do
    GenServer.call(String.to_atom(id), :get_current_song)
  end

  def update_current_song(state) do
    index = cond do
      Enum.count(state.playlist) - 1 <= state.index -> 0
      true -> state.index + 1
    end

    song = Enum.at(state.playlist, index)

    {stdout, _} = System.cmd("mp3info",
      ["-p", "\"%S\"", Path.join("/home/fervil/Downloads/songs", song)])

    song_length = String.trim(stdout) |> String.replace("\"", "")

    Map.put(state, :index, index)
    |> Map.put(:song, song)
    |> Map.put(:song_length, String.to_integer(song_length))
    |> Map.put(:time, 0)
    |> Map.put(:timestamp, Time.utc_now())
  end

  def update_current_time(state) do
    current_time = state.time + Time.diff(Time.utc_now() ,state.timestamp)
    time = cond do
      state.time + 1 <= current_time -> state.time + 1
      true -> state.time
    end
    if state.song_length <= time do
      update_current_song(state)
    else
      if time > state.time do
        Map.put(state, :time, time)
        |> Map.put(:timestamp, Time.utc_now())
      else
        Map.put(state, :time, time)
      end
    end
  end

  @impl true
  def init(playlist_id) do
    playlist = Radio.get_playlist(playlist_id)

    song = Enum.at(playlist, 0)

    {stdout, _} = System.cmd("mp3info",
      ["-p", "\"%S\"", Path.join("/home/fervil/Downloads/songs", song)])

    song_length = String.trim(stdout) |> String.replace("\"", "")

    state = %{
      song: song,
      index: 0,
      playlist: playlist,
      time: 0,
      song_length: String.to_integer(song_length),
      timestamp: Time.utc_now()
    }

    schedule_update()

    {:ok, state}
  end

  def start_link(playlist_id) do
    GenServer.start_link(__MODULE__, playlist_id, name: __MODULE__)
  end

  @impl true
  def handle_info(:time, state) do
    schedule_update()
    {:noreply, update_current_time(state)}
  end

  @impl true
  def handle_call(:get_current_song, _from, state) do
    {:reply, state.song, state}
  end
end
