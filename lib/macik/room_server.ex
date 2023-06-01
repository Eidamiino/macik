defmodule Macik.RoomServer do
  use GenServer

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def join do
    GenServer.call(__MODULE__, :join)
  end

  def get_count do
    GenServer.call(__MODULE__, :get_count)
  end

  def init(_) do
    {:ok, 0}  # 0 users at the beginning
  end

  def handle_call(:join, _from, count) do
    new_count = count + 1
    {:reply, new_count, new_count}
  end

  def handle_call(:get_count, _from, count) do
    {:reply, count, count}
  end
end
