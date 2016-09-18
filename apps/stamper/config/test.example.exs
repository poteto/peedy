use Mix.Config

config :stamper, Stamper.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "stamper_repo_#{Mix.env}",
  username: "username",
  password: "password",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
