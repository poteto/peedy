defmodule PeedyWeb.Api.V1.DevNullControllerTest do
  use PeedyWeb.ConnCase

  test "create returns 200", %{conn: conn} do
    status =
      conn
      |> post(dev_null_path(conn, :create, %{"id" => 1}))
      |> Map.get(:status)

    assert status == 200
  end
end
