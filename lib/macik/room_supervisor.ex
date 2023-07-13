defmodule Macik.RoomSupervisor do
  use DynamicSupervisor

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(args) do
    DynamicSupervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def start_room(room_id) do
    spec = %{id: room_id, start: {Macik.RoomServer, :start_link, [room_id]}}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def delete_room(pid) do
    DynamicSupervisor.terminate_child(__MODULE__, pid)
  end

  @impl true
  def init(_) do
    {:ok, pid} = DynamicSupervisor.init(strategy: :one_for_one)
    {:ok, pid}
  end


end
