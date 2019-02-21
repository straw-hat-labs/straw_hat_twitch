defmodule StrawHat.Twitch.Chat do
  alias StrawHat.Twitch.Chat.{Message, State}

  def connect(state) do
    with {:ok, conn_pid} <- :gun.open(state.host, 443),
         {:ok, _} = :gun.await_up(conn_pid),
         _ref = :gun.ws_upgrade(conn_pid, "/"),
         do: {:ok, conn_pid}
  end

  def disconnect(state) do
    :gun.close(state.conn_pid)
  end

  def initial_state(opts) do
    State.new(opts)
  end

  def save_conn_pid(state, conn_pid) do
    State.save_conn_pid(state, conn_pid)
  end

  def authenticate(state) do
    state
    |> socket_message(Message.password(state.credentials.password), filtered: true)
    |> socket_message(Message.nick(state.credentials.username))
  end

  def send_message(state, channel_name, message) do
    socket_message(state, Message.message(channel_name, message))
  end

  def join_channel(state, channel_name) do
    socket_message(state, Message.join(channel_name))
  end

  def leave_channel(state, channel_name) do
    socket_message(state, Message.part(channel_name))
  end

  def handle_message(state, message) do
    cond do
      Message.ping?(message) -> send_pong_message(state)
      Message.welcome_message?(message) -> set_ready(state)
      Message.join?(message) -> add_channel(state, message)
      Message.part?(message) -> remove_channel(state, message)
      Message.private_message?(message) -> notify_message(state, message)
      true -> state
    end
  end

  defp notify_message(state, message) do
    parsed_message = Message.parse_private_message(message)
    caller = self()

    Task.async(fn ->
      state.message_broker.publish(caller, parsed_message)
    end)

    state
  end

  defp send_pong_message(state) do
    socket_message(state, Message.pong())
  end

  defp set_ready(state) do
    State.ready(state)
  end

  defp add_channel(state, message) do
    channel_name =
      message
      |> Message.parse_join()
      |> Map.get("channel_name")

    State.add_channel(state, channel_name)
  end

  defp remove_channel(state, message) do
    channel_name =
      message
      |> Message.parse_part()
      |> Map.get("channel_name")

    State.remove_channel(state, channel_name)
  end

  defp socket_message(state, message, _opts \\ []) do
    :gun.ws_send(state.conn_pid, {:text, message})
    state
  end
end
