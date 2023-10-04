defmodule Radio.PlaylistSongTest do
  use Radio.DataCase

  test "[PLAYLIST SONG] test association with song" do
    association = %Ecto.Association.BelongsTo{
      cardinality: :one,
      defaults: [],
      field: :song,
      on_cast: nil,
      on_replace: :raise,
      owner: PlaylistSong,
      owner_key: :song_id,
      queryable: Song,
      related: Song,
      related_key: :id,
      relationship: :parent,
      unique: true
    }

    assert PlaylistSong.__schema__(:association, :song) == association
  end

  test "[PLAYLIST SONG] test association with playlist" do
    association = %Ecto.Association.BelongsTo{
      cardinality: :one,
      defaults: [],
      field: :playlist,
      on_cast: nil,
      on_replace: :raise,
      owner: PlaylistSong,
      owner_key: :playlist_id,
      queryable: Playlist,
      related: Playlist,
      related_key: :id,
      relationship: :parent,
      unique: true
    }

    assert PlaylistSong.__schema__(:association, :playlist) == association
  end
end
