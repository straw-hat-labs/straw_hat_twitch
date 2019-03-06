defmodule StrawHat.Twitch.MessageBroker.EchoTest do
  use ExUnit.Case, async: true

  alias StrawHat.Twitch.IRC.Message
  alias StrawHat.Twitch.IRC.MessageBroker.Echo

  test "echoing the message back to the chat server" do
    Echo.publish(self(), %Message{
      channel_name: "alchemist_ubi",
      username: "alchemist_ubi",
      body: "Hello, World"
    })

    assert_receive {_, {:send_message, "alchemist_ubi", "Hello, World"}}
  end
end
