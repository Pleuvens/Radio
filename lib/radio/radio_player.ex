defmodule RadioPlayer do
  use GenServer

  def start_link(playlist_id) do
    GenServer.start_link(__MODULE__, playlist_id, name: __MODULE__)
  end

  @impl true
  def init(playlist_id) do
    state = %{}

    {:ok, state}
  end 
end
