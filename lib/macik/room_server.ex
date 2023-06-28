defmodule Macik.RoomServer do
  use GenServer

  def start_link(room) do
    GenServer.start_link(__MODULE__, room, name: room)
    IO.inspect(room, label: "zapinam")
  end

  def join(room) do
    GenServer.call(room, {:join, room})
  end

  def leave(room) do
    GenServer.call(room, {:leave, room})
  end

  def get_count(room, state) do
    Map.get(state, room, 0)
  end

  defp update_count(room, count, state) do
    Map.put(state, room, count)
  end

  def init(room) do
    {:ok, %{room => 0}}
  end

  def handle_call({:join, room}, _from, state) do
    new_count = get_count(room, state) + 1
    {:reply, new_count, update_count(room, new_count, state)}
  end

  def handle_call({:leave, room}, _from, state) do
    new_count = get_count(room, state) - 1
    {:reply, new_count, update_count(room, new_count, state)}
  end

  def handle_call({:get_count, room}, _from, state) do
    count = get_count(room, state)
    {:reply, count, state}
  end
end
