defmodule PlaylistSong do
  use Ecto.Schema

  schema "playlists_songs" do
    field :position, :integer
    belongs_to :playlist, Playlist
    belongs_to :song, Song
  end
end
