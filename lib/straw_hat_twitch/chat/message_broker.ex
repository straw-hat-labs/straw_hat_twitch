defmodule StrawHat.Twitch.Chat.MessageBroker do
  @callback publis(pid) :: :no_return
end
