defmodule Radio.PlaylistTest do
  use Radio.DataCase

  test "[PLAYLIST] playlist entry can't be empty" do
    refute Playlist.changeset(%Playlist{}, %{}).valid?
    refute Playlist.changeset(%Playlist{}, %{name: nil}).valid?
    refute Playlist.changeset(%Playlist{}, %{name: ""}).valid?
  end

  test "[PLAYLIST] simple valid playlist entry" do
    changeset = Playlist.changeset(%Playlist{}, %{name: "test playlist"})

    assert changeset.valid? == true
  end
end
