defmodule Queue.Pipeline.Processor do
  require Logger

  @interval 5_000

  def start_link(message) do
    {:ok, _} = Task.start_link(__MODULE__, :process_message, [message])
  end

  def process_message(message) do
    :timer.sleep(@interval)
    message
    |> inspect()
    |> Logger.info()
  end
end
