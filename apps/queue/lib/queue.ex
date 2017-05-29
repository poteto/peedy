defmodule Queue do
  @strategy Queue.Simple.Queue

  @doc """
  Adds a message into the queue. Is async.
  """
  def enqueue(message, strategy \\ @strategy),
    do: strategy.enqueue(message)

  @doc """
  Dequeues messages from the queue.
  """
  def dequeue(count \\ 1, strategy \\ @strategy) when is_integer(count),
    do: strategy.dequeue(count)
end
