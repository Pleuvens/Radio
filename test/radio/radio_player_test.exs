defmodule Radio.RadioPlayerTest do
  use Radio.DataCase

  setup do
    RadioPlayer.start_link("test")
    :ok
  end

  test "[RADIO PLAYER] get current song" do
    song = RadioPlayer.get_current_song("test")
    assert song.current_song == 0
  end
end
