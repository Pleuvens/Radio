defmodule RadioPlayer do
  use GenServer
  import Ecto.Query

  def init_db do
    query = from p in Playlist, where: p.name == "test"

    if !Radio.Repo.exists?(query) do
      {_, p} = Playlist.API.put("test")

      Song.API.put(
        "Entre 4 murs",
        "Bekar",
        154,
        "https://lpradio-dev.s3.eu-west-3.amazonaws.com/Bekar+-+Entre+4+murs+(clip+officiel).mp3",
        1,
        p
      )

      Song.API.put(
        "Présidentiel flow",
        "H JeuneCrack",
        161,
        "https://lpradio-dev.s3.eu-west-3.amazonaws.com/H+JeuneCrack+-+Pr%C3%A9sidentiel+flow.mp3",
        2,
        p
      )

      Song.API.put(
        "Fine on the Outside",
        "When Marnie Was There",
        254,
        "https://lpradio-dev.s3.eu-west-3.amazonaws.com/When+Marnie+Was+There+-+Fine+on+the+Outside.mp3",
        3,
        p
      )

      Song.API.put(
        "Rock with you",
        "Ateyaba",
        198,
        "https://lpradio-dev.s3.eu-west-3.amazonaws.com/Ateyaba+-+Rock+With+You+(Clip+Officiel).mp3",
        4,
        p
      )

      Song.API.put(
        "Yung Bratz by XXXTentacion but it's lofi hip hop",
        "Zeuz",
        118,
        "https://lpradio-dev.s3.eu-west-3.amazonaws.com/Yung+Bratz+by+XXXTentacion+but+its+lofi+hip+hop+radio+-+beats+to+relaxstudy+to..mp3",
        5,
        p
      )

      Song.API.put(
        "Sorcier",
        "So La Lune",
        177,
        "https://lpradio-dev.s3.eu-west-3.amazonaws.com/So+La+Lune+-+Sorcier+%5BClip+Officiel%5D.mp3",
        6,
        p
      )

      Song.API.put(
        "Reflet",
        "Aladin 135",
        225,
        "https://lpradio-dev.s3.eu-west-3.amazonaws.com/Aladin+135+-+Reflet+(Clip+Officiel).mp3",
        7,
        p
      )

      Song.API.put(
        "Ca va bien s'passer",
        "Flynt & JeanJass",
        213,
        "https://lpradio-dev.s3.eu-west-3.amazonaws.com/FLYNT+-+Ca+va+bien+spasser+(avec+Jeanjass).mp3",
        8,
        p
      )

      Song.API.put(
        "Aux souvenirs oubliés",
        "Nusky & Vaati",
        379,
        "https://lpradio-dev.s3.eu-west-3.amazonaws.com/X2Download.app+-+Nusky+%26+Vaati+-+Aux+Souvenirs+Oubli%C3%A9s+(Clip+Officiel)+(320+kbps).mp3",
        9,
        p
      )

      Song.API.put(
        "Pippo Inzaghi",
        "JeanJass",
        197,
        "https://lpradio-dev.s3.eu-west-3.amazonaws.com/JeanJass+-+Pippo+Inzaghi.mp3",
        10,
        p
      )

      Song.API.put(
        "Jeune d'en bas",
        "Lesram",
        200,
        "https://lpradio-dev.s3.eu-west-3.amazonaws.com/Lesram+-+Jeune+den+Bas.mp3",
        11,
        p
      )

      Song.API.put(
        "Ready or not",
        "Vesti & Sheldon",
        215,
        "https://lpradio-dev.s3.eu-west-3.amazonaws.com/Vesti+%26+Sheldon+-+Ready+Or+Not.mp3",
        12,
        p
      )

      Song.API.put(
        "Kiwibunnylove",
        "Nelick",
        142,
        "https://lpradio-dev.s3.eu-west-3.amazonaws.com/NELICK+-+KIWIBUNNYLOVE.mp3",
        13,
        p
      )

      Song.API.put(
        "99 en peuf",
        "Kyo Itachi & Alpha Wann",
        151,
        "https://lpradio-dev.s3.eu-west-3.amazonaws.com/99+en+peuf.mp3",
        14,
        p
      )
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

    Phoenix.PubSub.broadcast(
      Radio.PubSub,
      "radio_playertest",
      {:play_next_song, %{song: song, time: time}}
    )
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

      play_song(Enum.at(state.songs, next_song), 0)
      Process.send_after(self(), :timeout, 1000)
      {:noreply, %{state | current_song: next_song, s_played: 0}}
    end
  end
end
