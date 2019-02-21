defmodule StrawHat.Twitch.TestSupport.MessageBroker do
  @behaviour StrawHat.Twitch.Chat.MessageBroker

  def publish(caller, message) do
    {caller, message}
  end
end
