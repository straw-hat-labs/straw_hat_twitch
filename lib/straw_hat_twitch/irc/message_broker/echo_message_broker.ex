defmodule StrawHat.Twitch.IRC.EchoMessageBroker do
  @moduledoc """
  Echos the new messages back to the channel that receive the message.
  """
  @behaviour StrawHat.Twitch.IRC.MessageBroker

  alias StrawHat.Twitch.IRC.Server

  @impl StrawHat.Twitch.IRC.MessageBroker
  def publish(caller, message) do
    Server.send_message(caller, message.channel_name, message.body)
  end
end
