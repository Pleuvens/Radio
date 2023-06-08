defmodule Playlist do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

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

  defmodule API do
    def get(name) do
      query = from p in Playlist,
        join: s in assoc(p, :songs),
        where: p.name == ^name,
        preload: [songs: s]
      Radio.Repo.all(query)
      |> Enum.map(fn p -> %{id: p.id, name: p.name, songs: Enum.map(p.songs, fn s -> %{id: s.id, name: s.name, artists: s.artists, duration: s.duration, path: s.path} end)} end)
    end

    def put(name) do
      Playlist.changeset(%Playlist{}, %{name: name})
      |> Radio.Repo.insert()
    end
  end
end
