defmodule Macik.RoomServer do
  use GenServer

  #API
  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def join do
    GenServer.call(__MODULE__, :join)
  end

  #callbacks
  def init(_) do
    {:ok, 0}  #0 users at the beginning
  end

  def handle_call(:join, _from, count) do
    new_count = count + 1
    {:reply, new_count, new_count}
  end
end
