defmodule Macik.RoomSupervisor do
  use DynamicSupervisor
  def start_link do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(args) do
    DynamicSupervisor.start_link(__MODULE__, args, name: __MODULE__)
    Agent.start_link(fn -> %{} end, name: :existing_rooms)
  end

  def add_room(room_name, pid) do
    Agent.update(:existing_rooms, fn map -> Map.put(map, room_name, pid) end)
    current_map = Agent.get(:existing_rooms, fn map -> map end)
    IO.inspect(current_map, label: "Current map")
  end

  def start_room(room_id) do
    spec = %{id: room_id, start: {Macik.RoomServer, :start_link, [room_id]}}
    {:ok, pid} = DynamicSupervisor.start_child(__MODULE__, spec)
    {:ok, pid}
  end

  def room_exists?(room_name) do
    existing_rooms = Agent.get(:existing_rooms, & &1)
    Map.get(existing_rooms, room_name)
  end

  @impl true
  def init(_) do
    {:ok, pid} = DynamicSupervisor.init(strategy: :one_for_one)
    {:ok, pid}
  end
end
