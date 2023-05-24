defmodule MacikWeb.PageController do
  import :rand
  use MacikWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def test(conn, _params) do
    # testovaci stranka
    render(conn, :test, layout: false)
  end

  def index(conn, _params) do
    quizzes = [
      %{
        max_player_count: 0,
        current_player_count: 0,
        room_state: :running,
        created_at: DateTime.utc_now()
      },
      %{
        max_player_count: 0,
        current_player_count: 0,
        room_state: :in_lobby,
        created_at: DateTime.utc_now()
      },
      %{
        max_player_count: 0,
        current_player_count: 0,
        room_state: :ended,
        created_at: DateTime.utc_now()
      }
    ]

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(quizzes))
  end

  def random_quizzes(conn, %{"amount" => amount}) do
    amount = String.to_integer(amount)

    quizzes =
      if amount < 0 do
        []
      else
        generate_quizzes(amount)
      end

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(quizzes))
  end

  defp generate_quizzes(amount) do
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
