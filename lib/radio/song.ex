defmodule Song do
  use Ecto.Schema
  import Ecto.Changeset

  schema "songs" do
    field :name, :string
    field :artists, :string
    field :duration, :integer
    field :path, :string
    has_many :playlists_songs, PlaylistSong
    has_many :playlists, through: [:playlists_songs, :playlist]
  end

  def changeset(song, params \\ %{}) do
    song
    |> cast(params, [:name, :artists, :duration, :path])
    |> validate_required([:name, :artists, :duration, :path])
  end
end
