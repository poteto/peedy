defmodule PeedyWeb.Api.V1.DevNullController do
  require Logger
  use PeedyWeb.Web, :controller

  def create(conn, %{"id" => id} = params) do
    params
    |> Map.drop(["id"])
    |> Map.values()
    |> Enum.map(fn %Plug.Upload{filename: filename, path: path} ->
      "[#{id}] #{filename} located at #{path}"
    end)
    |> Enum.map(&Logger.info/1)

    send_resp(conn, :ok, "OK")
  end
end
