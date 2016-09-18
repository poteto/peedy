defmodule PeedyWeb.HealthcheckControllerTest do
  use PeedyWeb.ConnCase

  test "index returns 200", %{conn: conn} do
    status =
      conn
      |> get("/healthcheck")
      |> Map.get(:status)

    assert status == 200
  end
end
