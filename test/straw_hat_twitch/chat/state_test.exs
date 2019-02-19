defmodule StrawHat.Twitch.StateTests do
  use ExUnit.Case, async: true
  alias StrawHat.Twitch.Chat.{State, Credentials}

  @credentials Credentials.new("alchemist_ubi", "123")

  test "creating a State struct" do
    # I have no clue why my coverage is down even when I am doing this inside
    # my source code today, I just prefer to keep my coverage app, but, this is
    # innecessary, don't do this
    assert %State{}
  end

  test "tracking a new channel" do
    state =
      @credentials
      |> State.new()
      |> State.add_channel("alchemist_ubi")

    assert state.channels == ["alchemist_ubi"]
  end

  test "tracking a duplicated channel" do
    state =
      @credentials
      |> State.new()
      |> State.add_channel("alchemist_ubi")
      |> State.add_channel("alchemist_ubi")

    assert state.channels == ["alchemist_ubi"]
  end

  test "untracking a channel" do
    state =
      @credentials
      |> State.new()
      |> State.add_channel("admiralbulldog")
      |> State.add_channel("alchemist_ubi")
      |> State.remove_channel("admiralbulldog")

    assert state.channels == ["alchemist_ubi"]
  end

  test "untracking a non-existing channel" do
    state =
      @credentials
      |> State.new()
      |> State.add_channel("admiralbulldog")
      |> State.add_channel("alchemist_ubi")
      |> State.remove_channel("gorgc")

    assert state.channels == ["alchemist_ubi", "admiralbulldog"]
  end

  test "mark as ready" do
    state =
      @credentials
      |> State.new()
      |> State.ready()

    assert state.is_ready == true
  end

  test "saving Connection PID" do
    state =
      @credentials
      |> State.new()
      |> State.save_conn_pid("123")

    assert state.conn_pid == "123"
  end
end
