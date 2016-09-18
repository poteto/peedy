use Mix.Config

config :watermarker, Watermarker.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "watermarker_repo_#{Mix.env}",
  username: "username",
  password: "password",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :watermarker, :layout, "#{File.cwd!}/apps/watermarker/lib/layouts/template.html.eex"
