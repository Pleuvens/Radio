defmodule Playlist do
  use Ecto.Schema
  import Ecto.Changeset

  schema "playlists" do
    field :name, :string
    field :theme, :string
    belongs_to :user, User
    has_many :playlists_songs, PlaylistSong
    has_many :songs, through: [:playlists_songs, :song]
  end

  def changeset(playlist, params \\ %{}) do
    playlist
    |> cast(params, [:name, :theme])
    |> validate_required([:name])
  end
end
