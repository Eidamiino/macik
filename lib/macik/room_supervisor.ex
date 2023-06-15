defmodule Macik.RoomSupervisor do
  use DynamicSupervisor

  def start_link do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def start_link(args) do
    DynamicSupervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def start_room(room_id) do
    spec = %{id: room_id, start: {Macik.RoomServer, :start_link, [room_id]}}
    {:ok, pid} = DynamicSupervisor.start_child(__MODULE__, spec)
    {room_id, pid}
  end

  @impl true
  def init(_) do
    {:ok, pid} = DynamicSupervisor.init(strategy: :one_for_one)
    # start_room(:macik_room)
    {:ok, pid}
  end
end
