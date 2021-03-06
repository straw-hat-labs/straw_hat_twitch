defmodule StrawHat.Twitch.IRC.ClientState do
  @moduledoc """
  A IRC client state.
  """

  alias StrawHat.Twitch.IRC.Credentials

  @enforce_keys [:credentials, :conn_pid, :is_ready, :channels, :message_broker, :host]
  defstruct [:credentials, :conn_pid, :is_ready, :channels, :message_broker, :host]

  @default_endpoint 'irc-ws.chat.twitch.tv'

  @typedoc """
  - `conn_pid`: `gun` connection PID.
  - `is_ready`: defines if the chatbot is ready to interact with.
  - `channels`: list of channels currently listen to.
  - `message_broker`: message broker module used that gets notify the private
  messages.
  - `host`: Twitch server host.
  """
  @type t :: %__MODULE__{
          conn_pid: pid() | nil,
          credentials: %Credentials{},
          is_ready: boolean(),
          channels: [String.t()],
          message_broker: module(),
          host: binary()
        }

  @doc false
  def new(opts) do
    %__MODULE__{
      conn_pid: nil,
      credentials: opts.credentials,
      is_ready: false,
      channels: [],
      message_broker: opts.message_broker,
      host: Map.get(opts, :host, @default_endpoint)
    }
  end

  @doc false
  def add_channel(state, channel_name) do
    if has_channel?(state, channel_name) do
      state
    else
      channels = [channel_name] ++ state.channels
      Map.put(state, :channels, channels)
    end
  end

  @doc false
  def remove_channel(state, channel_name) do
    if has_channel?(state, channel_name) do
      channels = List.delete(state.channels, channel_name)
      Map.put(state, :channels, channels)
    else
      state
    end
  end

  @doc false
  def ready(state) do
    Map.put(state, :is_ready, true)
  end

  @doc false
  def save_conn_pid(state, conn_pid) do
    Map.put(state, :conn_pid, conn_pid)
  end

  @doc false
  def has_channel?(state, channel_name) do
    Enum.member?(state.channels, channel_name)
  end
end
