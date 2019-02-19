defmodule StrawHat.Twitch.Chat.Credentials do
  @enforce_keys [:password, :username]
  defstruct [:password, :username]

  def new(username, password) do
    %__MODULE__{
      password: password,
      username: String.downcase(username)
    }
  end
end
