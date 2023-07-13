defmodule Macik.RoomManager do
  use GenServer

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # def join(room) do
  #   IO.inspect(room, label: "joinRoom")
  #   GenServer.call(room, {:join, room})
  # end

  # def handle_call({:join, room}, _from, state) do
  #   new_count = get_count(room, state) + 1
  #   {:reply, new_count, update_count(room, new_count, state)}
  # end
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

  def start(room_id) when is_atom(room_id) do
    GenServer.call(__MODULE__, {:start, room_id})
  end

  @impl true
  def init(_) do
    IO.puts("valliiiim")
    {:ok, %{}}
  end
end
