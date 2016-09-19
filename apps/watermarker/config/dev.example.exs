use Mix.Config

config :watermarker, Watermarker.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "watermarker_repo_#{Mix.env}",
  username: "username",
  password: "password",
  hostname: "localhost"
