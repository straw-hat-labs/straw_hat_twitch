defmodule StrawHat.Twitch.IRC.EchoMessageBroker do
  @moduledoc """
  Echos the new messages back to the channel that receive the message.
  """
  @behaviour StrawHat.Twitch.IRC.MessageBroker

  @impl StrawHat.Twitch.IRC.MessageBroker
  def publish(caller, message) do
    StrawHat.Twitch.IRCServer.send_message(caller, message.channel_name, message.body)
  end
end
