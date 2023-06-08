defmodule PlaylistSong do
  use Ecto.Schema

  schema "playlists_songs" do
    field :position, :integer
    belongs_to :playlist, Playlist
    belongs_to :song, Song
  end

  defmodule API do
    def get(id) do
      Radio.Repo.get!(PlaylistSong, id)
    end

    def put(position, playlist, song) do
      %PlaylistSong{position: position, playlist: playlist, song:  song}
      |> Radio.Repo.insert()
    end
  end
end
