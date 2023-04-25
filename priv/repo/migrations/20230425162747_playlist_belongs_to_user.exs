defmodule Radio.Repo.Migrations.PlaylistBelongsToUser do
  use Ecto.Migration

  def change do
    alter table(:playlists) do
      add :user, references(:users)
    end
  end
end
