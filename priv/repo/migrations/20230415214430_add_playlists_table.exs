defmodule Radio.Repo.Migrations.AddPlaylistsTable do
  use Ecto.Migration

  def change do
    create table(:playlists) do
      add :name, :string
      add :theme, :string
    end
  end
end
