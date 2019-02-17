defmodule StrawHat.Twitch.Chat do
  alias StrawHat.Twitch.Chat.{Credentials, Message}

  @twitch_endpoint 'irc-ws.chat.twitch.tv'
  @timeout 1000 * 60

  def connect do
    with {:ok, conn_pid} <- :gun.open(@twitch_endpoint, 443),
         {:ok, _} = :gun.await_up(conn_pid),
         _ref = :gun.ws_upgrade(conn_pid, "/"),
         do: {:ok, conn_pid}
  end

  def disconnect(state) do
    :gun.close(state.conn_pid)
  end

  def authenticate(state) do
    socket_message(state, Message.password(state.credentials.password), [filtered: true])
    socket_message(state, Message.nick(state.credentials.username))
  end

  def send_channel_message(state, channel_name, message) do
    socket_message(state, Message.message(channel_name, message))
  end

  def join_channel(state, channel_name) do
    if Enum.member?(state.channels, channel_name) do
      state
    else
      socket_message(state, Message.join(channel_name))
    end
  end

  def leave_channel(state, channel_name) do
    if Enum.member?(state.channels, channel_name) do
      socket_message(state, Message.part(channel_name))
    else
      state
    end
  end

  def handle_message(state, message) do
    cond do
      Message.ping?(message) -> send_pong_message(state)
      Message.welcome_message?(message) -> set_ready(state)
      Message.join?(message) -> add_channel(state, message)
      Message.part?(message) -> remove_channel(state, message)
      true -> state
    end
  end

  defp send_pong_message(state) do
    socket_message(state, Message.pong())
  end

  defp set_ready(state) do
    Map.put(state, :is_ready, true)
  end

  defp add_channel(state, message) do
    channel_name =
      message
      |> Message.parse_join()
      |> Map.get("channel_name")
    channels = [channel_name] ++ state.channels
    Map.put(state, :channels, channels)
  end

  defp remove_channel(state, message) do
    channel_name =
      message
      |> Message.parse_part()
      |> Map.get("channel_name")
    channels = List.delete(state.channels, channel_name)
    Map.put(state, :channels, channels)
  end

  defp socket_message(state, message, opts \\ []) do
    :gun.ws_send(state.conn_pid, {:text, message})
    state
  end
end
