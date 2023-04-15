defmodule Song do
  use Ecto.Schema
  import Ecto.Changeset

  schema "songs" do
    field :name, :string
    field :artists, :string
    field :path, :string
    belongs_to :playlist, Playlist
  end

  def changeset(song, params \\ %{}) do
    song
    |> cast(params, [:name, :artists, :path])
    |> validate_required([:name, :artists, :path])
  end
end
