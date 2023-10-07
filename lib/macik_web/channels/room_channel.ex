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


  def handle_in("join", %{"room" => room_name}, socket) do
    IO.inspect(room_name, label: "Join payload")

    room_name_atom=String.to_atom(room_name)

    pid=Macik.RoomManager.start(room_name_atom)

    count = Macik.RoomServer.join(pid)
    IO.inspect(count, label: "Join count")

    broadcast(socket, "join", %{count: count, message: "Join successful"})
    {:noreply, socket}
  end

  @impl true
  def handle_in("leave", %{"room" => room_name}, socket) do
    IO.inspect(room_name, label: "Leave payload")

    room_name_atom=String.to_atom(room_name)
    pid = Macik.RoomManager.start(room_name_atom)

    count = Macik.RoomServer.leave(pid)
    IO.inspect(count, label: "Leave count")
    broadcast(socket, "leave", %{count: count, message: "Leave successful"})
    {:noreply, socket}
  end

  defp authorized?(_payload) do
    true
  end
end
