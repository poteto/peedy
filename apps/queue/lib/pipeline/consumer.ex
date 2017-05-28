defmodule Queue.Pipeline.Consumer do
  use ConsumerSupervisor

  @min_concurrency Application.get_env(:queue, :concurrency)[:min]
  @max_concurrency Application.get_env(:queue, :concurrency)[:max]

  def start_link do
    ConsumerSupervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(Queue.Pipeline.Processor, [], restart: :temporary)
    ]

    {:ok, children, strategy: :one_for_one, subscribe_to: [
      {
        Queue.Pipeline.Producer,
        min_demand: @min_concurrency,
        max_demand: @max_concurrency
      }
    ]}
  end
end
