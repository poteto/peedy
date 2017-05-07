defmodule PeedyWeb.Mixfile do
  use Mix.Project

  def project do
    [app: :peedy_web,
     version: "0.0.1",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.4",
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
     extra_applications: [:logger, :watermarker, :stamper, :plug, :httpoison,
                          :toniq]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.3.0-rc"},
     {:phoenix_pubsub, "~> 1.0.1"},
     {:gettext, "~> 0.13.1"},
     {:cowboy, "~> 1.1.2"},
     {:plug, "~> 1.3.5"},
     {:httpoison, "~> 0.11.2"},
     {:zarex, "~> 0.3.0"},
     {:toniq, "~> 1.2.1"},
     {:exredis, "~> 0.2.0"},

     {:f, in_umbrella: true},
     {:watermarker, in_umbrella: true},
     {:stamper, in_umbrella: true}]
  end
end
