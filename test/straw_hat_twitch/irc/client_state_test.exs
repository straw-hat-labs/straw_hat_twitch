defmodule StrawHat.Twitch.IRC.ClientStateTest do
  use ExUnit.Case, async: true
  alias StrawHat.Twitch.IRC.{ClientState, Credentials}
  alias StrawHat.Twitch.TestSupport.MessageBroker

  @credentials Credentials.new("alchemist_ubi", "123")

  @default_state ClientState.new(%{
                   credentials: @credentials,
                   message_broker: MessageBroker
                 })

  test "creating a IRC client struct" do
    # I have no clue why my coverage is down even when I am doing this inside
    # my source code today, I just prefer to keep my coverage app, but, this is
    # innecessary, don't do this
    assert %ClientState{
      conn_pid: nil,
      credentials: %{},
      is_ready: false,
      channels: [],
      message_broker: __MODULE__,
      host: 'something'
    }
  end

  test "tracking a new channel" do
    state = ClientState.add_channel(@default_state, "alchemist_ubi")

    assert state.channels == ["alchemist_ubi"]
  end

  test "tracking a duplicated channel" do
    state =
      @default_state
      |> ClientState.add_channel("alchemist_ubi")
      |> ClientState.add_channel("alchemist_ubi")

    assert state.channels == ["alchemist_ubi"]
  end

  test "untracking a channel" do
    state =
      @default_state
      |> ClientState.add_channel("admiralbulldog")
      |> ClientState.add_channel("alchemist_ubi")
      |> ClientState.remove_channel("admiralbulldog")

    assert state.channels == ["alchemist_ubi"]
  end

  test "untracking a non-existing channel" do
    state =
      @default_state
      |> ClientState.add_channel("admiralbulldog")
      |> ClientState.add_channel("alchemist_ubi")
      |> ClientState.remove_channel("gorgc")

    assert state.channels == ["alchemist_ubi", "admiralbulldog"]
  end

  test "mark as ready" do
    state = ClientState.ready(@default_state)

    assert state.is_ready == true
  end

  test "saving Connection PID" do
    state = ClientState.save_conn_pid(@default_state, "123")

    assert state.conn_pid == "123"
  end
end
