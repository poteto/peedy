use Mix.Config

config :peedy_f, PeedyF.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "peedyf_repo_#{Mix.env}",
  username: "username",
  password: "password",
  hostname: "localhost"
