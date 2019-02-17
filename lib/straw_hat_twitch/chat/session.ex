defmodule StrawHat.Twitch.Chat.Session do
  defstruct [:username, :conn_pid]

  def new(conn_pid, username) do
    %__MODULE__{
      conn_pid: conn_pid,
      username: username
    }
  end
end
