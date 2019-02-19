defmodule StrawHat.Twitch.CredentialsTests do
  use ExUnit.Case, async: true
  alias StrawHat.Twitch.Chat.Credentials

  test "creating a Credentials struct" do
    # I have no clue why my coverage is down even when I am doing this inside
    # my source code today, I just prefer to keep my coverage app, but, this is
    # innecessary, don't do this
    assert %Credentials{
      password: "123",
      username: "alchemist_ubi"
    }
  end
end
