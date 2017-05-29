defmodule Queue.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Queue.Simple.Queue.Supervisor, []),
      supervisor(Queue.Pipeline.Supervisor, [])
    ]

    opts = [strategy: :rest_for_one, name: Queue.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
