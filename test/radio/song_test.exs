defmodule Radio.SongTest do
  use Radio.DataCase

  test "[SONG] song entry can't be empty" do
    changeset = Song.changeset(%Song{}, %{})
    refute changeset.valid?
  end
end
