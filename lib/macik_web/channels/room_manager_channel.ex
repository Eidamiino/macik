defmodule MacikWeb.RoomManagerChannel do
  use MacikWeb, :channel

  @impl true
  def join("room:" <> room_name, payload, socket) do
    IO.puts("pomoc join volani")
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_in("get_all_rooms", _payload, socket) do
    IO.puts("roommanagerchannel get all rooms called")
    rooms = Macik.RoomManager.get_all_rooms() |> Map.keys()
    IO.inspect(rooms)
    {:reply, {:ok, rooms}, socket}
  end

  defp authorized?(_payload) do
    true
  end
end
