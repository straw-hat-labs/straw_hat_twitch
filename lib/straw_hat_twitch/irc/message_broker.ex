defmodule StrawHat.Twitch.IRC.MessageBroker do
  @moduledoc """
  Message Brokers are used for listening to new messages coming from Twitch chat.
  This allow you to transform or do some async actions on the message.
  """

  @doc """
  It receive a message from the Twitch chat. The `caller` is the `PID` of the
  `StrawHat.Twitch.IRC.Server` that received the message.

  You can use the `caller` to send messages back to the subscribed chat server.

  For example, the following message broker echos the message back:

      defmodule EchoMessageBroker do
        @behaviour StrawHat.Twitch.IRC.MessageBroker

        @impl StrawHat.Twitch.IRC.MessageBroker
        def publish(caller, message) do
          # Notice how we use `caller` to send a message back to the GenServer.
          StrawHat.Twitch.IRC.Server.send_message(caller, message.channel_name, message.body)
        end
      end
  """
  @callback publish(caller :: pid, message :: StrawHat.Twitch.IRC.Message.t()) :: no_return
end
