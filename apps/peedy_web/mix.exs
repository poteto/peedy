defmodule PeedyWeb.Mixfile do
  use Mix.Project

  def project do
    [app: :peedy_web,
     version: "0.0.1",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {PeedyWeb, []},
     applications: [:phoenix, :phoenix_pubsub, :cowboy, :logger, :gettext,
                    :watermarker, :stamper, :plug, :httpoison]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.2.0"},
     {:phoenix_pubsub, "~> 1.0"},
     {:gettext, "~> 0.11"},
     {:cowboy, "~> 1.0"},
     {:plug, "~> 1.2"},
     {:httpoison, "~> 0.9"},
     {:zarex, "~> 0.3"},

     {:f, in_umbrella: true},
     {:watermarker, in_umbrella: true},
     {:stamper, in_umbrella: true}]
  end
end
