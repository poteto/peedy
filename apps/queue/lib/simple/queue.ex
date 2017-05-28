defmodule Queue.Simple.Queue do
  @moduledoc """
  Simple queue. Backed by a stream to handle large collections.
  """
  use GenServer

  # Init with stream-ified initial state.
  def init(state) when is_list(state),
    do: {:ok, Stream.concat(state)}
  def init(state),
    do: {:ok, Stream.concat([state])}

  # GenServer API
  def handle_call({:dequeue, count}, _from, state) do
    values =
      state
      |> Stream.take(count)
      |> Enum.to_list()
    {:reply, values, Stream.drop(state, count)}
  end

  def handle_cast({:enqueue, value}, state) when is_list(value) do
    {:noreply, Stream.concat(state, value)}
  end
  def handle_cast({:enqueue, value}, state) do
    {:noreply, Stream.concat(state, [value])}
  end

  # Client API
  def start_link(state, opts \\ []),
    do: GenServer.start_link(__MODULE__, state, opts)

  def enqueue(value),
    do: GenServer.cast(__MODULE__, {:enqueue, value})
  def dequeue(count \\ 1),
    do: GenServer.call(__MODULE__, {:dequeue, count})
end
