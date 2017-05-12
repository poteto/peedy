defmodule Queue.Pipeline.Producer do
  use GenStage
  require Logger
  alias Queue.SimpleQueue

  def start_link(state \\ 0) do
    GenStage.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    {:producer, state}
  end

  def handle_cast(:check_messages, 0), do: {:noreply, [], 0}
  def handle_cast(:check_messages, state) when is_integer(state) do
    messages = SimpleQueue.dequeue(state)

    GenStage.cast(__MODULE__, :check_messages)

    {:noreply, messages, state - Enum.count(messages)}
  end

  def handle_demand(demand, state) when is_integer(state) do
    GenStage.cast(__MODULE__, :check_messages)

    {:noreply, [], demand + state}
  end
end
