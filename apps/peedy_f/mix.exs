defmodule PeedyF.Mixfile do
  use Mix.Project

  def project do
    [app: :peedy_f,
     version: "0.1.0",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.4",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [extra_applications: [:logger],
     mod: {PeedyF, []}]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # To depend on another app inside the umbrella:
  #
  #   {:myapp, in_umbrella: true}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:porcelain, "~> 2.0.3"},
     {:ecto, "~> 2.1.4"},
     {:postgrex, ">= 0.0.0"},
     {:toniq, "~> 1.2.1"},
     {:erlguten, github: "hwatkins/erlguten", branch: "master"},
     {:exredis, "~> 0.2.5"},
     {:zarex, "~> 0.3"}]
  end
end
