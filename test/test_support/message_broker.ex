defmodule StrawHat.Twitch.TestSupport.MessageBroker do
  @moduledoc false

  @behaviour StrawHat.Twitch.IRC.MessageBroker

  def publish(caller, message) do
    {caller, message}
  end
end
