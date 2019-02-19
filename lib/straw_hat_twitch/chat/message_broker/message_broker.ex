defmodule StrawHat.Twitch.Chat.MessageBroker do
  alias StrawHat.Twitch.Chat.Message

  @callback publish(pid, %Message{}) :: :no_return
end
