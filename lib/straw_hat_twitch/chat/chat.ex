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

  defp upgrade_websocket(conn_pid) do
    :gun.ws_upgrade(conn_pid, "/")

    receive do
      {:gun_upgrade, _, _, [<<"websocket">>], _} -> {:ok, conn_pid}
      _ -> {:error, :websocket_upgrade_failed}
    after
      @timeout -> {:error, :websocket_upgrade_timeout}
    end
  end
end
