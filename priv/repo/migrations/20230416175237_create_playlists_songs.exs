defmodule Radio.Repo.Migrations.CreatePlaylistsSongs do
  use Ecto.Migration

  def change do
    create table(:playlists_songs) do
      add :position, :integer
      add :playlist_id, references(:playlists)
      add :song_id, references(:songs)
    end

    create unique_index(:playlists_songs, [:playlist_id, :song_id])
  end
end
