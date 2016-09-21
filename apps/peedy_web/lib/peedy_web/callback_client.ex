defmodule PeedyWeb.CallbackClient do
  use Toniq.Worker, max_concurrency: Application.get_env(:peedy_web, :max_concurrency)
  alias Stamper.{Repo,Document}
  @adapter HTTPoison

  def do_callback(callback_url, %{file: file, id: id}, headers, adapter \\ @adapter) do
    Toniq.enqueue(PeedyWeb.CallbackClient,
      callback_url: callback_url,
      file: file,
      id: id,
      headers: headers,
      adapter: adapter)
  end

  def perform(callback_url: callback_url, file: file, id: id, headers: headers, adapter: adapter) do
    adapter.post(callback_url, multipart_encode([file: file, id: id]), headers)
    Repo.get!(Document, id)
  end

  defp multipart_encode(body) do
    body = Enum.map(body, fn {:file, path} -> {:file, path}
                              {key, value} -> {to_string(key), value} end)
    {:multipart, body}
  end
end
