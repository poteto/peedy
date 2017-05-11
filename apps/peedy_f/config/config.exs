# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :peedy_f,
  ecto_repos: [PeedyF.Repo]

config :toniq, redis_url: "redis://localhost:6379/0"
config :peedy_f, max_concurrency: 10

config :peedy_f, :executables,
  pdftk: System.find_executable("pdftk")
config :peedy_f, :executables,
  nodejs: System.find_executable("node")

# Ignore goon
config :porcelain, goon_warn_if_missing: false

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
#     config :peedy_f, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:peedy_f, :key)
#
# Or configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
import_config "#{Mix.env}.exs"
