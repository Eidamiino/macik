defmodule MacikWeb.RoomChannel do
  use MacikWeb, :channel

  @impl true
  def join("room:" <> room_name, payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).

  # stary check na existing
  # {room_name, pid} =
  #   case DynamicSupervisor.which_children(Macik.RoomSupervisor) do
  #     children ->
  #       child = List.first(Enum.filter(children, fn {_, pid, _, _} -> pid != nil end))

  #       case child do
  #         {_, pid, _, _} -> {room_name, pid}
  #         _ -> {room_name, Macik.RoomSupervisor.start_room(room_name)}
  #       end

  #     [] ->
  #       {room_name, Macik.RoomSupervisor.start_room(room_name)}
  #   end

  def handle_in("join", %{"room" => room_name}, socket) do
    IO.inspect(room_name, label: "Join payload")

    # pid = Macik.RoomSupervisor.room_exists?(room_name)
    # if(pid) do
    # else
    #   {:ok, pid} = Macik.RoomSupervisor.start_room(room_name)
    #   Macik.RoomSupervisor.add_room(room_name, pid)
    # end
    room_name_atom=String.to_atom(room_name)

    pid=Macik.RoomManager.start(room_name_atom)

    count = Macik.RoomServer.join(pid)
    IO.inspect(count, label: "Join count")

    broadcast(socket, "join", %{count: count, message: "Join successful"})
    {:noreply, socket}
  end

  @impl true
  def handle_in("leave", payload, socket) do
    IO.inspect(payload, label: "Leave payload")
    count = Macik.RoomServer.leave()
    IO.inspect(count, label: "Leave count")
    broadcast(socket, "leave", %{count: count, message: payload})
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
