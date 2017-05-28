defmodule Queue.Pipeline.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(Queue.Pipeline.Producer, []),
      supervisor(Queue.Pipeline.Consumer, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
