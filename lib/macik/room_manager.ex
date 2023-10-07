defmodule Macik.RoomManager do
  use GenServer

  def start(room_id) when is_atom(room_id) do
    GenServer.call(__MODULE__, {:start, room_id})
  end

  def get_all_rooms() do
    GenServer.call(__MODULE__, :get_all_rooms)
  end

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_) do
    IO.puts("manager init")
    {:ok, %{}}
  end

  # state je mapa micu
  # state.rooms

  @impl true
  def handle_call({:start, room_id}, _from, state) do
    case Map.fetch(state, room_id) do
      :error ->
        {:ok, pid} = Macik.RoomSupervisor.start_room(room_id)
        new_map = Map.put(state, room_id, pid)
        {:reply, pid, new_map}

      {:ok, pid} ->
        {:reply, pid, state}
    end
  end
  def handle_call(:get_all_rooms, _from, state) do
    IO.puts("returning all rooms")

    {:reply, state, state}
  end
end
