defmodule Queue do
  @strategy Queue.SimpleQueue

  @doc """
  Adds a message into the queue. Is async.
  """
  def enqueue(message, strategy \\ @strategy),
    do: strategy.enqueue(message)

  @doc """
  Adds messages into the queue. Is async.
  """
  def enqueue_all(messages, strategy \\ @strategy) when is_list(messages) do
    messages
    |> Stream.map(&strategy.enqueue/1)
    |> Enum.to_list()
  end

  @doc """
  Fetch all messages from the queue without dequeueing them.
  """
  def queue(strategy \\ @strategy),
    do: strategy.queue()

  @doc """
  Dequeues messages from the queue.
  """
  def dequeue(count \\ 1, strategy \\ @strategy) when is_integer(count),
    do: strategy.dequeue(count)
end
