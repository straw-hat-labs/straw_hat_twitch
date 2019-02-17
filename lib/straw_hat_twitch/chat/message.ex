defmodule StrawHat.Twitch.Chat.Message do
  alias StrawHat.Twitch.Chat.Session

  def password(password) do
    "PASS #{password}"
  end

  def nick(username) do
    "NICK #{username}"
  end

  def pong do
    "PONG :tmi.twitch.tv"
  end

  def join(channel_name) do
    "JOIN ##{channel_name}"
  end

  def depart(channel_name) do
    "PART ##{channel_name}"
  end

  def on_depart(%Session{} = session, channel_name) do
    full_username = full_username(session)
    channel = channel_name(channel_name)

    "#{full_username} PART #{channel}\r\n"
  end

  def message(channel_name, message) do
    "PRIVMSG ##{channel_name} :#{message}"
  end

  def full_username(%Session{} = session) do
    ":#{session.username}!#{session.username}@#{username(session)}"
  end

  def username(session) do
    "#{session.username}.tmi.twitch.tv"
  end

  def channel_name(channel_name) do
    "##{channel_name}"
  end

  def on_join_first(%Session{} = session, channel_name) do
    full_username = full_username(session)

    "#{full_username} JOIN ##{channel_name}\r\n"
  end

  def on_join_second(%Session{} = session, channel_name) do
    username = username(session)
    channel = channel_name(channel_name)

    first_chunk = ":#{username} 353 #{session.username} = #{channel} :#{session.username}\r\n"
    second_chunk = ":#{username} 366 #{session.username} #{channel} :End of /NAMES list\r\n"

    "#{first_chunk}#{second_chunk}"
  end
end
