defmodule Radio.Repo.Migrations.SongBelongsToPlaylist do
  use Ecto.Migration

  def change do
    alter table(:songs) do
      add :playlist_id, references(:playlists)
    end
  end
end
