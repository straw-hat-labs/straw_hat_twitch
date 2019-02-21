defmodule StrawHat.Twitch.EchoMessageBrokerTests do
  use ExUnit.Case, async: true

  alias StrawHat.Twitch.Chat.Message
  alias StrawHat.Twitch.Chat.EchoMessageBroker

  test "echoing the message back to the chat server" do
    EchoMessageBroker.publish(self(), %Message{
      channel_name: "alchemist_ubi",
      username: "alchemist_ubi",
      body: "Hello, World"
    })

    assert_receive {_, {:send_message, "alchemist_ubi", "Hello, World"}}
  end
end
