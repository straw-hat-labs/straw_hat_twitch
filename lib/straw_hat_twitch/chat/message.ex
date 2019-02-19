defmodule StrawHat.Twitch.Chat.Message do
  @enforce_keys [:username, :channel_name, :body]
  defstruct [:username, :channel_name, :body]

  def password(password) do
    "PASS #{password}"
  end

  def nick(username) do
    "NICK #{username}"
  end

  def pong do
    "PONG :tmi.twitch.tv"
  end

  def join(channel_name) do
    "JOIN ##{channel_name}"
  end

  def part(channel_name) do
    "PART ##{channel_name}"
  end

  def message(channel_name, message) do
    "PRIVMSG ##{channel_name} :#{message}"
  end

  def welcome_message?(message) do
    String.match?(message, ~r/:tmi.twitch.tv 001 \S+ :Welcome, GLHF!\r\n/)
  end

  def ping?(message) do
    message == "PING :tmi.twitch.tv\r\n"
  end

  def private_message?(message) do
    String.match?(message, ~r/\S+ PRIVMSG #\S+/)
  end

  def join?(message) do
    String.match?(message, ~r/\S+ JOIN #\S+/)
  end

  def part?(message) do
    String.match?(message, ~r/\S+ PART #\S+/)
  end

  def parse_join(message) do
    Regex.named_captures(~r/JOIN #(?<channel_name>\S+)/, message)
  end

  def parse_part(message) do
    Regex.named_captures(~r/PART #(?<channel_name>\S+)/, message)
  end

  def parse_private_message(message) do
    parsed_message = Regex.named_captures(
      ~r/:(?<username>\S+)!\S+ PRIVMSG #(?<channel_name>\S+)+ :(?<message>[^\\\r]+)/,
      message
    )

    %__MODULE__{
      username: parsed_message["username"],
      channel_name: parsed_message["channel_name"],
      body: parsed_message["message"]
    }
  end
end
