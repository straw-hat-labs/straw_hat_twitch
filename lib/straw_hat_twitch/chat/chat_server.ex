defmodule StrawHat.Twitch.ChatServer do
  alias StrawHat.Twitch.Chat
  alias StrawHat.Twitch.Chat.Credentials

  @typedoc """
  Indentifier of the chat genserver.
  """
  @type chat_server_pid :: pid()

  @typedoc """
  - `credentials`: the credentials for authenticate the bot.
  - `message_broker`: module that implements `StrawHat.Twitch.Chat.MessageBroker`.
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
  @spec start_link(chat_server_pid, opts) :: {:ok, pid}
  def start_link(name, opts) do
    GenServer.start_link(__MODULE__, opts, name: name)
  end

  @doc """
  Subscribe to a channel, listening for incoming messages.
  """
  @spec join_channel(chat_server_pid, String.t()) :: :ok
  def join_channel(pid, channel_name) do
    GenServer.cast(pid, {:join_channel, channel_name})
  end

  @doc """
  Unsubscribe from a channel.
  """
  @spec leave_channel(chat_server_pid, String.t()) :: :ok
  def leave_channel(pid, channel_name) do
    GenServer.cast(pid, {:leave_channel, channel_name})
  end

  @doc """
  Send a message to a channel.
  """
  @spec send_message(chat_server_pid, String.t(), String.t()) :: :ok
  def send_message(pid, channel_name, message) do
    GenServer.cast(pid, {:send_message, channel_name, message})
  end

  @doc false
  def init(opts) do
    state = Chat.initial_state(opts)
    {:ok, state, {:continue, :connect_socket}}
  end

  @doc false
  def handle_continue(:connect_socket, state) do
    {:ok, conn_pid} = Chat.connect(state)
    state = Chat.save_conn_pid(state, conn_pid)
    {:noreply, state}
  end

  @doc false
  def handle_cast({:join_channel, channel_name}, state) do
    state = Chat.join_channel(state, channel_name)
    {:noreply, state}
  end

  @doc false
  def handle_cast({:leave_channel, channel_name}, state) do
    state = Chat.leave_channel(state, channel_name)
    {:noreply, state}
  end

  @doc false
  def handle_cast({:send_message, channel_name, message}, state) do
    state = Chat.send_message(state, channel_name, message)
    {:noreply, state}
  end

  @doc false
  def handle_info({:gun_upgrade, _, _, [<<"websocket">>], _}, state) do
    state = Chat.authenticate(state)
    {:noreply, state}
  end

  @doc false
  def handle_info({:gun_ws, _, _, {:text, message}}, state) do
    state = Chat.handle_message(state, message)
    {:noreply, state}
  end

  @doc false
  def handle_info(_message, state) do
    {:noreply, state}
  end
end
