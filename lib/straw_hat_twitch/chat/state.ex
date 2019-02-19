defmodule StrawHat.Twitch.Chat.State do
  @enforce_keys [:credentials, :conn_pid, :is_ready, :channels, :message_broker]
  defstruct [:credentials, :conn_pid, :is_ready, :channels, :message_broker]

  def new(credentials, message_broker) do
    %__MODULE__{
      conn_pid: nil,
      credentials: credentials,
      is_ready: false,
      channels: [],
      message_broker: message_broker
    }
  end

  def add_channel(state, channel_name) do
    if has_channel?(state, channel_name) do
      state
    else
      channels = [channel_name] ++ state.channels
      Map.put(state, :channels, channels)
    end
  end

  def remove_channel(state, channel_name) do
    if has_channel?(state, channel_name) do
      channels = List.delete(state.channels, channel_name)
      Map.put(state, :channels, channels)
    else
      state
    end
  end

  def ready(state) do
    Map.put(state, :is_ready, true)
  end

  def save_conn_pid(state, conn_pid) do
    Map.put(state, :conn_pid, conn_pid)
  end

  def has_channel?(state, channel_name) do
    Enum.member?(state.channels, channel_name)
  end
end
