defmodule StrawHat.Twitch.Chat.EchoMessageBroker do
  @behaviour StrawHat.Twitch.Chat.MessageBroker

  @impl StrawHat.Twitch.Chat.MessageBroker
  def publish(caller, message) do
    Task.async(fn ->
      StrawHat.Twitch.ChatServer.send_message(caller, message.username, message.body)
    end)
  end
end
