defmodule Radio.Repo.Migrations.AddUserTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :pseudo, :string
    end
  end
end
