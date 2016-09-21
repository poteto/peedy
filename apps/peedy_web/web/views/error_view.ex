defmodule PeedyWeb.ErrorView do
  use PeedyWeb.Web, :view

  def render(view, assigns)
  def render("400.json", %{detail: detail}) do
    %{title: "Bad request", code: 400, detail: "Bad request"}
    |> Map.merge(%{detail: detail})
  end

  def render("404.json", %{detail: detail}) do
    %{title: "Not found", code: 404, detail: "Not found"}
    |> Map.merge(%{detail: detail})
  end

  def render("500.json", %{detail: detail}) do
    %{title: "Internal server error", code: 500, detail: "Internal server error"}
    |> Map.merge(%{detail: detail})
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.json", assigns
  end
end
