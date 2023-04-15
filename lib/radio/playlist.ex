defmodule Playlist do
  use Ecto.Schema
  import Ecto.Changeset

  schema "playlists" do
    field :name, :string
    field :theme, :string
    has_many :songs, Song
  end

  def changeset(playlist, params \\ %{}) do
    playlist
    |> cast(params, [:name, :theme])
    |> validate_required([:name])
  end
end
