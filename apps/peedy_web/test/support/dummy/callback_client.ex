defmodule PeedyWeb.Dummy.CallbackClient do
  def post(_callback_url, _opts, _headers) do
    :ok
  end
end
