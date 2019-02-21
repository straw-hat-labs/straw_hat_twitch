defmodule StrawHat.Twitch.Chat.EchoMessageBroker do
  @moduledoc """
  Echos the new messages back to the channel that receive the message.
  """
  @behaviour StrawHat.Twitch.Chat.MessageBroker

  @impl StrawHat.Twitch.Chat.MessageBroker
  def publish(caller, message) do
    StrawHat.Twitch.ChatServer.send_message(caller, message.channel_name, message.body)
  end
end
