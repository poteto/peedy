defmodule Queue.Pipeline.Consumer do
  use ConsumerSupervisor

  def start_link do
    ConsumerSupervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(Queue.Pipeline.Processor, [], restart: :temporary)
    ]

    {:ok, children, strategy: :one_for_one, subscribe_to: [
      {Queue.Pipeline.Producer, max_demand: 10, min_demand: 1}
    ]}
  end
end
