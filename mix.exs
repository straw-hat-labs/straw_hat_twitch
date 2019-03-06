defmodule StrawHat.Twitch.MixProject do
  use Mix.Project

  @name :straw_hat_twitch
  @version "0.0.1"
  @elixir_version "~> 1.8"
  @source_url "https://github.com/straw-hat-team/straw_hat_twitch"

  def project do
    production? = Mix.env() == :prod

    [
      name: "StrawHat.Twitch",
      description: "A Twitch client",
      app: @name,
      version: @version,
      deps: deps(),
      elixir: @elixir_version,
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: production?,
      aliases: aliases(),
      test_coverage: test_coverage(),
      preferred_cli_env: cli_env(),
      package: package(),
      docs: docs()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:gun, "~> 1.3"},

      # Testing
      {:mock, "~> 0.3.3"},

      # Tools
      {:dialyxir, ">= 0.0.0", only: [:dev], runtime: false},
      {:credo, ">= 0.0.0", only: [:dev, :test], runtime: false},
      {:excoveralls, ">= 0.0.0", only: [:test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: [:dev], runtime: false}
    ]
  end

  defp test_coverage do
    [tool: ExCoveralls]
  end

  defp cli_env do
    [
      "coveralls.html": :test,
      "coveralls.json": :test
    ]
  end

  defp aliases do
    [
      test: ["test --trace"]
    ]
  end

  defp package do
    [
      name: @name,
      files: [
        "lib",
        "mix.exs",
        "README*",
        "LICENSE*"
      ],
      maintainers: ["Yordis Prieto"],
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp docs do
    [
      main: "readme",
      homepage_url: @source_url,
      source_ref: "v#{@version}",
      source_url: @source_url,
      extras: ["README.md"],
      groups_for_modules: [
        "Chatbots & IRC": [
          StrawHat.Twitch.IRC.Credentials,
          StrawHat.Twitch.IRC.Server,
          StrawHat.Twitch.IRC.Client,
          StrawHat.Twitch.IRC.ClientState,
          StrawHat.Twitch.IRC.Message,
        ],
        "Message Brokers": [
          StrawHat.Twitch.IRC.MessageBroker,
          StrawHat.Twitch.IRC.MessageBroker.Echo,
        ],
      ]
    ]
  end
end
