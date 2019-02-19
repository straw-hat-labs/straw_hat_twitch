defmodule StrawHat.Twitch.ChatServer do
  alias StrawHat.Twitch.Chat

  def start_link(name, opts) do
    GenServer.start_link(__MODULE__, opts, name: name)
  end

  def join_channel(pid, channel_name) do
    GenServer.cast(pid, {:join_channel, channel_name})
  end

  def leave_channel(pid, channel_name) do
    GenServer.cast(pid, {:leave_channel, channel_name})
  end

  def send_message(pid, channel_name, message) do
    GenServer.cast(pid, {:send_message, channel_name, message})
  end

  def init(opts) do
    state = Chat.initial_state(opts)
    {:ok, state, {:continue, :connect_socket}}
  end

  def handle_continue(:connect_socket, state) do
    {:ok, conn_pid} = Chat.connect()
    state = Chat.save_conn_pid(state, conn_pid)
    {:noreply, state}
  end

  def handle_cast({:join_channel, channel_name}, state) do
    state = Chat.join_channel(state, channel_name)
    {:noreply, state}
  end

  def handle_cast({:leave_channel, channel_name}, state) do
    state = Chat.leave_channel(state, channel_name)
    {:noreply, state}
  end

  def handle_cast({:send_message, channel_name, message}, state) do
    state = Chat.send_message(state, channel_name, message)
    {:noreply, state}
  end

  def handle_info({:gun_upgrade, _, _, [<<"websocket">>], _}, state) do
    state = Chat.authenticate(state)
    {:noreply, state}
  end

  def handle_info({:gun_ws, _, _, {:text, message}}, state) do
    state = Chat.handle_message(state, message)
    {:noreply, state}
  end

  def handle_info(_message, state) do
    {:noreply, state}
  end
end
