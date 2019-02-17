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

  def add_channel(state, channel_name) do
    channels = [channel_name] ++ state.channels
    Map.put(state, :channels, channels)
  end

  def remove_channel(state, channel_name) do
    channels = List.delete(state.channels, channel_name)
    Map.put(state, :channels, channels)
  end

  def ready(state) do
    Map.put(state, :is_ready, true)
  end

  def has_channel?(state, channel_name) do
    Enum.member?(state.channels, channel_name)
  end
end
