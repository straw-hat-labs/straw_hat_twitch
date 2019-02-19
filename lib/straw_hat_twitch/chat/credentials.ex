defmodule StrawHat.Twitch.Chat.Credentials do
  @moduledoc """
  Twitch Chat credentials used for authenticating the bot.
  """

  @enforce_keys [:password, :username]
  defstruct [:password, :username]

  @typedoc """
  - `username`: the account (username) that the chatbot uses to send chat
  messages. This can be your Twitch account. Alternately, many developers
  choose to create a second Twitch account for their bot, so it's clear from
  whom the messages originate.
  - `password`: the token to authenticate your chatbot with Twitch's servers.
  Generate this with https://twitchapps.com/tmi/ (a Twitch community-driven
  wrapper around the Twitch API), while logged in to your chatbot account.
  The token will be an alphanumeric string.
  """
  @type t :: %__MODULE__{
    username: String.t(),
    password: String.t()
  }

  @doc """
  Returns new credentials.
  """
  @spec new(String.t(), String.t()) :: %__MODULE__{}
  def new(username, password) do
    %__MODULE__{
      password: password,
      username: String.downcase(username)
    }
  end
end
