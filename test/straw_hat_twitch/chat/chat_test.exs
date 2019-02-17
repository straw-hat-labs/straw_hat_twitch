# defmodule StrawHat.Twitch.ChatTests do
#   use ExUnit.Case, async: true

#   alias StrawHat.Twitch.ChatServer
#   alias StrawHat.Twitch.Chat.Credentials

#   setup do
#     channel_name = "alchemist_ubi"
#     username = "alchemist_ubi"
#     password = System.get_env("TWITCH_CHAT_PASSWORD")
#     credentials = Credentials.new(username, password)

#     {:ok, chat_server} = ChatServer.start_link(:alchemist_ubi, credentials)
#     # :ok = Chat.send_channel_message(chat_server, channel_name, "Hello")
#     #  Chat.join_channel(chat_server, channel_name)
#     # Chat.depart_channel(chat_server, "asdss")

#     %{chat_server: chat_server}
#   end

#   test "connecting to twitch IRC chat", %{chat_server: chat_server} do
#     ref = Process.monitor(Process.whereis(:alchemist_ubi))
#     assert_receive {:DOWN, ^ref, :process, _, :normal}, 10_000_000
#   end
# end

# def testing do
#   alias StrawHat.Twitch.ChatServer
#   alias StrawHat.Twitch.Chat.Credentials

#   channel_name = "alchemist_ubi"
#   username = "alchemist_ubi"
#   password = System.get_env("TWITCH_CHAT_PASSWORD")
#   credentials = Credentials.new(username, password)

#   ChatServer.start_link(:alchemist_ubi, credentials)
# end
