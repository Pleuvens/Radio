defmodule Radio.SongTest do
  use Radio.DataCase

  test "[SONG] song entry can't be empty" do
    refute Song.changeset(%Song{}, %{}).valid?
    refute Song.changeset(%Song{}, %{name: nil, artists: nil, duration: nil, path: nil}).valid?
    refute Song.changeset(%Song{}, %{name: "", artists: "", duration: "", path: ""}).valid?
  end

  test "[SONG] song field name can't be blank" do
    refute Song.changeset(%Song{}, %{artists: "an artist", duration: 0, path: "the path"}).valid?

    refute Song.changeset(%Song{}, %{
             name: nil,
             artists: "an artist",
             duration: 0,
             path: "the path"
           }).valid?

    refute Song.changeset(%Song{}, %{
             name: "",
             artists: "an artist",
             duration: 0,
             path: "the path"
           }).valid?
  end

  test "[SONG] song field artists can't be blank" do
    refute Song.changeset(%Song{}, %{name: "title", duration: 0, path: "the path"}).valid?

    refute Song.changeset(%Song{}, %{name: "title", artists: nil, duration: 0, path: "the path"}).valid?

    refute Song.changeset(%Song{}, %{name: "title", artists: "", duration: 0, path: "the path"}).valid?
  end

  test "[SONG] song field duration can't be blank" do
    refute Song.changeset(%Song{}, %{name: "title", artists: "an artist", path: "the path"}).valid?

    refute Song.changeset(%Song{}, %{
             name: "title",
             artists: "an artist",
             duration: nil,
             path: "the path"
           }).valid?

    refute Song.changeset(%Song{}, %{
             name: "title",
             artists: "an artist",
             duration: "",
             path: "the path"
           }).valid?
  end

  test "[SONG] song field path can't be blank" do
    refute Song.changeset(%Song{}, %{name: "title", artists: "an artist", duration: 0}).valid?

    refute Song.changeset(%Song{}, %{name: "title", artists: "an artist", duration: 0, path: nil}).valid?

    refute Song.changeset(%Song{}, %{name: "title", artists: "an artist", duration: 0, path: ""}).valid?
  end

  test "[SONG] simple valid song entry" do
    changeset =
      Song.changeset(%Song{}, %{
        name: "Entre 4 murs",
        artists: "Bekar",
        duration: 154,
        path:
          "https://lpradio-dev.s3.eu-west-3.amazonaws.com/Bekar+-+Entre+4+murs+(clip+officiel).mp3"
      })

    assert changeset.valid? == true
  end
end
