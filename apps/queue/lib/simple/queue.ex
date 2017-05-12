defmodule Queue.SimpleQueue do
  @moduledoc """
  Simple FIFO queue.
  """
  use GenServer

  def init(state), do: {:ok, state}

  # GenServer API
  def handle_call(:all, _from, []),
    do: {:reply, [], []}
  def handle_call(:all, _from, state) when is_list(state),
    do: {:reply, state, []}

  def handle_call(:dequeue, _from, []),
    do: {:reply, nil, []}
  def handle_call(:dequeue, _from, [value | state]),
    do: {:reply, value, state}

  def handle_call({:dequeue, _}, _from, []),
    do: {:reply, [], []}
  def handle_call({:dequeue, count}, _from, state) when is_list(state) do
    values = Enum.take(state, count)
    {:reply, values, state -- values}
  end

  def handle_call(:queue, _from, state),
    do: {:reply, state, state}

  def handle_cast({:enqueue, value}, state),
    do: {:noreply, state ++ [value]}

  # Client API
  def start_link(state, opts \\ []),
    do: GenServer.start_link(__MODULE__, state, opts)

  def all,
    do: GenServer.call(__MODULE__, :all)
  def queue,
    do: GenServer.call(__MODULE__, :queue)
  def enqueue(value),
    do: GenServer.cast(__MODULE__, {:enqueue, value})
  def dequeue(count),
    do: GenServer.call(__MODULE__, {:dequeue, count})
  def dequeue,
    do: GenServer.call(__MODULE__, :dequeue)
end
