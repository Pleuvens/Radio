defmodule Radio.Repo.Migrations.AddSongsTable do
  use Ecto.Migration

  def change do
    create table(:songs) do
      add :name, :string
      add :artists, :string
      add :duration, :integer
      add :path, :string
    end
  end
end
