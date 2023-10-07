defmodule Macik.RoomServer do
  use GenServer

  @spec start_link(binary) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(room_atom) do
    # room_atom = String.to_atom(room)
    IO.inspect(room_atom, label: "zapinam")
    GenServer.start_link(__MODULE__, [room_atom], name: room_atom)
  end

  @spec join(atom | pid | {atom, any} | {:via, atom, any}) :: any
  def join(room) do
    IO.inspect(room, label: "joinRoom")
    GenServer.call(room, :join)
  end

  def leave(room) do
    IO.inspect(room, label: "leaveRoom")
    GenServer.call(room, :leave)
  end

  def get_count(state) do
    Map.get(state, :player_count, 0)
  end

  defp update_count(state, count) do
    Map.put(state, :player_count, count)
  end

  def init(room) do
    IO.inspect(room, label: "init room server")
    {:ok, %{player_count: 0, room_name: room}}
  end

  def handle_call(:join, _from, state) do
    new_count = get_count(state) + 1
    {:reply, new_count, update_count(state, new_count)}
  end

  def handle_call(:leave, _from, state) do
    new_count = get_count(state) - 1
    {:reply, new_count, update_count(state, new_count)}
  end

  def handle_call(:get_count, _from, state) do
    count = get_count(state)
    {:reply, count, state}
  end

end
