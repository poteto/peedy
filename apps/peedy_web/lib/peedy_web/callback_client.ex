defmodule PeedyWeb.CallbackClient do
  alias Stamper.{Repo,Document}
  @adapter HTTPoison

  def post(callback_url, %{file: file, id: id}, headers, adapter \\ @adapter) do
    adapter.post(callback_url, multipart_encode([file: file, id: id]), headers)
    Repo.get!(Document, id)
  end

  defp multipart_encode(body) do
    body = Enum.map(body, fn {:file, path} -> {:file, path}
                              {key, value} -> {to_string(key), value} end)
    {:multipart, body}
  end
end
