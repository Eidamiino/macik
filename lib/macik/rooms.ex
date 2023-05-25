defmodule Macik.Rooms do
  use GenServer

  def init(_) do
    {:ok, []}
  end

  def handle_call(:get_quizzes, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:generate_quizzes, amount}, state) do
    new_quizzes = random_quizzes(amount)
    updated_state = state ++ new_quizzes
    {:noreply, updated_state}
  end

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def get_quizzes() do
    GenServer.call(__MODULE__, :get_quizzes)
  end

  def generate_quizzes(amount) do
    GenServer.cast(__MODULE__, {:generate_quizzes, amount})
  end

  def random_quizzes(amount) do
    if amount < 0 do
      []
    else
      generate_quiz_list(amount)
    end
  end

  defp generate_quiz_list(amount) do
    room_states = [:running, :in_lobby, :ended]

    Enum.map(1..amount, fn _ ->
      max_player_count = :rand.uniform(20)
      current_player_count = :rand.uniform(max_player_count)

      room_state = Enum.random(room_states)

      %{
        max_player_count: max_player_count,
        current_player_count: current_player_count,
        room_state: room_state,
        created_at: DateTime.utc_now()
      }
    end)
  end
end
