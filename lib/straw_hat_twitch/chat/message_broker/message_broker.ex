defmodule StrawHat.Twitch.Chat.MessageBroker do
  @callback publish(caller :: pid, message :: StrawHat.Twitch.Chat.Message.t) :: no_return
end
