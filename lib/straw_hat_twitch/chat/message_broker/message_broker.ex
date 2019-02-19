defmodule StrawHat.Twitch.Chat.MessageBroker do
  @callback publish(pid, %StrawHat.Twitch.Chat.Message{}) :: :no_return
end
