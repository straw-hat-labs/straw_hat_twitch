defmodule StrawHat.Twitch do
  def testing do
    alias StrawHat.Twitch.ChatServer
    alias StrawHat.Twitch.Chat.Credentials

    username = "alchemist_ubi"
    password = System.get_env("TWITCH_CHAT_PASSWORD")
    credentials = Credentials.new(username, password)

    {:ok, pid} =
      ChatServer.start_link(:alchemist_ubi, %{
        credentials: credentials,
        message_broker: StrawHat.Twitch.Chat.EchoMessageBroker
      })

    pid
  end
end
