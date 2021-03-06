defmodule StrawHat.Twitch.IRC.Server do
  @moduledoc """
  A IRC client.

      password = System.get_env("TWITCH_CHAT_PASSWORD")
      credentials = StrawHat.Twitch.IRC.Credentials.new("my_twitch_channel", password)
      {:ok, pid} =
        StrawHat.Twitch.IRC.Server.start_link(:my_channel, %{
          credentials: credentials,
          message_broker: StrawHat.Twitch.IRC.MessageBroker.Echo
        })

  Using the `pid` you can send messages to ohter channels

      StrawHat.Twitch.IRC.Server.send_message(pid, "alchemist_ubi", "Hello, World")

  Now you can subscribe to a channel chat's thread.

      StrawHat.Twitch.IRC.Server.join_channel(pid, "alchemist_ubi")

  Or unsubscribe from a channel chat's thread

      StrawHat.Twitch.IRC.Server.leave_channel(pid, "alchemist_ubi")
  """

  alias StrawHat.Twitch.IRC.{Client, Credentials}

  @typedoc """
  Indentifier of the IRC genserver client.
  """
  @type server_pid :: pid()

  @typedoc """
  - `credentials`: the credentials for authenticate the bot.
  - `message_broker`: module that implements `StrawHat.Twitch.IRC.MessageBroker`.
  - `host`: Twitch Chat server host.
  """
  @type opts :: %{
          credentials: %Credentials{},
          message_broker: module(),
          host: binary()
        }

  @doc """
  Starts a new Chat server.
  """
  @spec start_link(server_pid, opts) :: {:ok, pid}
  def start_link(name, opts) do
    GenServer.start_link(__MODULE__, opts, name: name)
  end

  @doc """
  Subscribe to a channel, listening for incoming messages.
  """
  @spec join_channel(server_pid, String.t()) :: :ok
  def join_channel(pid, channel_name) do
    GenServer.cast(pid, {:join_channel, channel_name})
  end

  @doc """
  Unsubscribe from a channel.
  """
  @spec leave_channel(server_pid, String.t()) :: :ok
  def leave_channel(pid, channel_name) do
    GenServer.cast(pid, {:leave_channel, channel_name})
  end

  @doc """
  Send a message to a channel.
  """
  @spec send_message(server_pid, String.t(), String.t()) :: :ok
  def send_message(pid, channel_name, message) do
    GenServer.cast(pid, {:send_message, channel_name, message})
  end

  @doc false
  def init(opts) do
    state = Client.initial_state(opts)
    {:ok, state, {:continue, :connect_socket}}
  end

  @doc false
  def handle_continue(:connect_socket, state) do
    state = Client.connect(state)
    {:noreply, state}
  end

  @doc false
  def handle_cast({:join_channel, channel_name}, state) do
    state = Client.join_channel(state, channel_name)
    {:noreply, state}
  end

  @doc false
  def handle_cast({:leave_channel, channel_name}, state) do
    state = Client.leave_channel(state, channel_name)
    {:noreply, state}
  end

  @doc false
  def handle_cast({:send_message, channel_name, message}, state) do
    state = Client.send_message(state, channel_name, message)
    {:noreply, state}
  end

  @doc false
  def handle_info({:gun_upgrade, _, _, [<<"websocket">>], _}, state) do
    state = Client.authenticate(state)
    {:noreply, state}
  end

  @doc false
  def handle_info({:gun_ws, _, _, {:text, message}}, state) do
    state = Client.handle_message(state, message)
    {:noreply, state}
  end

  @doc false
  def handle_info(_message, state) do
    {:noreply, state}
  end
end
