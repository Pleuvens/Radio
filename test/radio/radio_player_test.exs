defmodule Radio.RadioPlayerTest do
  use Radio.DataCase

  setup do
    {_, pid} = RadioPlayer.start_link("test")
    :erlang.trace(pid, true, [:receive])
    {:ok, %{pid: pid}}
  end

  test "[RADIO PLAYER] get current song" do
    song = RadioPlayer.get_current_song("test")
    assert song.current_song == 0
  end

  test "[RADIO PLAYER] timeout callback triggered", %{pid: pid} do
    assert_receive {:trace, ^pid, :receive, :timeout}, 2_000
  end
end
