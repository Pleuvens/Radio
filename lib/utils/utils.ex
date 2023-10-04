defmodule Utils do
  import Ecto.Query

  def init_db(playlist_name) do
    query = from p in Playlist, where: p.name == ^playlist_name

    if !Radio.Repo.exists?(query) do
      {_, p} = Playlist.API.put(playlist_name)

      songs = [
        Song.API.put(
          "Entre 4 murs",
          "Bekar",
          154,
          "https://lpradio-dev.s3.eu-west-3.amazonaws.com/Bekar+-+Entre+4+murs+(clip+officiel).mp3"
        ),
        Song.API.put(
          "Présidentiel flow",
          "H JeuneCrack",
          161,
          "https://lpradio-dev.s3.eu-west-3.amazonaws.com/H+JeuneCrack+-+Pr%C3%A9sidentiel+flow.mp3"
        ),
        Song.API.put(
          "Fine on the Outside",
          "When Marnie Was There",
          254,
          "https://lpradio-dev.s3.eu-west-3.amazonaws.com/When+Marnie+Was+There+-+Fine+on+the+Outside.mp3"
        ),
        Song.API.put(
          "Rock with you",
          "Ateyaba",
          198,
          "https://lpradio-dev.s3.eu-west-3.amazonaws.com/Ateyaba+-+Rock+With+You+(Clip+Officiel).mp3"
        ),
        Song.API.put(
          "Yung Bratz by XXXTentacion but it's lofi hip hop",
          "Zeuz",
          118,
          "https://lpradio-dev.s3.eu-west-3.amazonaws.com/Yung+Bratz+by+XXXTentacion+but+its+lofi+hip+hop+radio+-+beats+to+relaxstudy+to..mp3"
        ),
        Song.API.put(
          "Sorcier",
          "So La Lune",
          177,
          "https://lpradio-dev.s3.eu-west-3.amazonaws.com/So+La+Lune+-+Sorcier+%5BClip+Officiel%5D.mp3"
        ),
        Song.API.put(
          "Reflet",
          "Aladin 135",
          225,
          "https://lpradio-dev.s3.eu-west-3.amazonaws.com/Aladin+135+-+Reflet+(Clip+Officiel).mp3"
        ),
        Song.API.put(
          "Ca va bien s'passer",
          "Flynt & JeanJass",
          213,
          "https://lpradio-dev.s3.eu-west-3.amazonaws.com/FLYNT+-+Ca+va+bien+spasser+(avec+Jeanjass).mp3"
        ),
        Song.API.put(
          "Aux souvenirs oubliés",
          "Nusky & Vaati",
          379,
          "https://lpradio-dev.s3.eu-west-3.amazonaws.com/X2Download.app+-+Nusky+%26+Vaati+-+Aux+Souvenirs+Oubli%C3%A9s+(Clip+Officiel)+(320+kbps).mp3"
        ),
        Song.API.put(
          "Pippo Inzaghi",
          "JeanJass",
          197,
          "https://lpradio-dev.s3.eu-west-3.amazonaws.com/JeanJass+-+Pippo+Inzaghi.mp3"
        ),
        Song.API.put(
          "Jeune d'en bas",
          "Lesram",
          200,
          "https://lpradio-dev.s3.eu-west-3.amazonaws.com/Lesram+-+Jeune+den+Bas.mp3"
        ),
        Song.API.put(
          "Ready or not",
          "Vesti & Sheldon",
          215,
          "https://lpradio-dev.s3.eu-west-3.amazonaws.com/Vesti+%26+Sheldon+-+Ready+Or+Not.mp3"
        ),
        Song.API.put(
          "Kiwibunnylove",
          "Nelick",
          142,
          "https://lpradio-dev.s3.eu-west-3.amazonaws.com/NELICK+-+KIWIBUNNYLOVE.mp3"
        ),
        Song.API.put(
          "99 en peuf",
          "Kyo Itachi & Alpha Wann",
          151,
          "https://lpradio-dev.s3.eu-west-3.amazonaws.com/99+en+peuf.mp3"
        )
      ]
      Enum.with_index(songs) |> Enum.each(fn {song, index} ->
        PlaylistSong.API.put(index, p, song)
      end)
    end
  end
end
