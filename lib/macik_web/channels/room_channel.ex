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
  @impl true
  def handle_in("join", payload, socket) do
  IO.inspect(payload, label: "Join payload")
  count = Macik.RoomServer.join()
  IO.inspect(count, label: "Join count")
  broadcast(socket, "join", %{count: count, message: payload})
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
