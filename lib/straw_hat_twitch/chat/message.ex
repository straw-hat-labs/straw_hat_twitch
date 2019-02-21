defmodule StrawHat.Twitch.Chat.Message do
  @moduledoc """
  A chat's message.
  """

  @enforce_keys [:username, :channel_name, :body]
  defstruct [:username, :channel_name, :body]

  @typedoc """
  - `username`: the account (username) that sent the message.
  - `channel_name`: the channel name the message was sent to.
  - `body`: the message body.
  """
  @type t :: %__MODULE__{
          username: String.t(),
          channel_name: String.t(),
          body: String.t()
        }

  @doc false
  def password(password) do
    "PASS #{password}"
  end

  @doc false
  def nick(username) do
    "NICK #{username}"
  end

  @doc false
  def pong do
    "PONG :tmi.twitch.tv"
  end

  @doc false
  def join(channel_name) do
    "JOIN ##{channel_name}"
  end

  @doc false
  def part(channel_name) do
    "PART ##{channel_name}"
  end

  @doc false
  def message(channel_name, message) do
    "PRIVMSG ##{channel_name} :#{message}"
  end

  @doc false
  def welcome_message?(message) do
    String.match?(message, ~r/:tmi.twitch.tv 001 \S+ :Welcome, GLHF!\r\n/)
  end

  @doc false
  def ping?(message) do
    message == "PING :tmi.twitch.tv\r\n"
  end

  @doc false
  def private_message?(message) do
    String.match?(message, ~r/\S+ PRIVMSG #\S+/)
  end

  @doc false
  def join?(message) do
    String.match?(message, ~r/\S+ JOIN #\S+/)
  end

  @doc false
  def part?(message) do
    String.match?(message, ~r/\S+ PART #\S+/)
  end

  @doc false
  def parse_join(message) do
    Regex.named_captures(~r/JOIN #(?<channel_name>\S+)/, message)
  end

  @doc false
  def parse_part(message) do
    Regex.named_captures(~r/PART #(?<channel_name>\S+)/, message)
  end

  @doc false
  def parse_private_message(message) do
    parsed_message =
      Regex.named_captures(
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
