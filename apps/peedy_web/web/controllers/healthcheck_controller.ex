defmodule PeedyWeb.HealthcheckController do
  use PeedyWeb.Web, :controller

  def index(conn, _params) do
    send_resp(conn, :ok, "OK")
  end
end
