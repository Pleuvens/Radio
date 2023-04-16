defmodule Radio.Repo.Migrations.CreatePlaylistsSongs do
  use Ecto.Migration

  def change do
    create table(:playlists_songs) do
      add :position, :integer
      add :playlist, references(:playlists)
      add :song, references(:songs)
    end

    create unique_index(:playlists_songs, [:playlist, :song])
  end
end
