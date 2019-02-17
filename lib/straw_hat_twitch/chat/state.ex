defmodule StrawHat.Twitch.Chat.State do
  defstruct [:credentials, :conn_pid, :is_ready, :channels]

  def new(credentials) do
    %__MODULE__{
      conn_pid: nil,
      credentials: credentials,
      is_ready: false,
      channels: []
    }
  end
end
