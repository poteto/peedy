defmodule PeedyWeb.ErrorViewTest do
  use PeedyWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 400.json" do
    assert render(PeedyWeb.ErrorView, "400.json") ==
           %{title: "Bad request", code: 400, detail: "Bad request"}
  end

  test "renders 404.json" do
    assert render(PeedyWeb.ErrorView, "404.json") ==
           %{title: "Page not found", code: 404, detail: "Page not found"}
  end

  test "render 500.json" do
    assert render(PeedyWeb.ErrorView, "500.json") ==
           %{title: "Internal server error", code: 500, detail: "Internal server error"}
  end

  test "render any other" do
    assert render(PeedyWeb.ErrorView, "505.json") ==
           %{title: "Internal server error", code: 505, detail: "Internal server error"}
  end
end
