defmodule StrawHat.Twitch.Chat do
  alias StrawHat.Twitch.Chat.{Credentials, Session, Message}

  @twitch_endpoint 'irc-ws.chat.twitch.tv'
  @timeout 1000 * 60

  def connect do
    with {:ok, conn_pid} <- :gun.open(@twitch_endpoint, 443),
         {:ok, _} = :gun.await_up(conn_pid),
         {:ok, conn_pid} = upgrade_websocket(conn_pid),
         do: {:ok, conn_pid}
  end

  def disconnect(%Session{} = session) do
    :gun.close(session.conn_pid)
  end

  def send_pong_message(conn_pid) do
    socket_message(conn_pid, Message.pong())
  end

  def send_channel_message(conn_pid, channel_name, message) do
    socket_message(conn_pid, Message.message(channel_name, message))
  end

  def authenticate(conn_pid, %Credentials{} = credentials) do
    socket_message(conn_pid, Message.password(credentials.password))
    socket_message(conn_pid, Message.nick(credentials.username))

    receive do
      {:gun_ws, _, _, frame} -> on_authenticate(conn_pid, credentials, frame)
      _ -> {:error, :authorization_failed}
    after
      @timeout -> {:error, :authorization_timeout}
    end
  end

  def depart_channel(session, channel_name) do
    socket_message(session.conn_pid, Message.depart())

    receive do
      {:gun_ws, _, _, frame} -> on_depart_channel(session, channel_name, frame)
      _ -> {:error, :depart_channel_failed}
    after
      @timeout -> {:error, :depart_channel_timeout}
    end
  end

  defp on_depart_channel(session, channel_name, {:text, message}) do
    if message == Message.on_depart(session, channel) do
      {:ok, session}
    else
      {:error, :depart_channel_failed}
    end
  end

  defp on_authenticate(conn_pid, credentials, _frame) do
    {:ok, Session.new(conn_pid, credentials.username)}
  end

  defp upgrade_websocket(conn_pid) do
    :gun.ws_upgrade(conn_pid, "/")

    receive do
      {:gun_upgrade, _, _, [<<"websocket">>], _} -> {:ok, conn_pid}
      _ -> {:error, :websocket_upgrade_failed}
    after
      @timeout -> {:error, :websocket_upgrade_timeout}
    end
  end

  defp socket_message(conn_pid, message) do
    :gun.ws_send(conn_pid, {:text, message})
  end
end
