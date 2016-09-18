defmodule Watermarker do
  use Application
  alias Watermarker.Strategies.{Html,Erlguten}

  @after_compile __MODULE__
  @wkhtmltopdf Application.get_env(:watermarker, :executables)[:wkhtmltopdf]

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      worker(Watermarker.Repo, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Watermarker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def create(text, strategy: :html) when is_binary(text),
    do: Html.new(text)
  def create(text, strategy: :erlguten) when is_binary(text),
    do: Erlguten.new(text)
  def create(text),
    do: create(text, strategy: :html)

  def __after_compile__(_env, _bytecode) do
    if is_nil(@wkhtmltopdf), do: raise error_msg("wkhtmltopdf")
  end

  defp error_msg(missing) do
    "Missing executable for `#{missing}`. Ensure it is installed."
  end
end
