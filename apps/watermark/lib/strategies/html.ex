defmodule Watermark.Strategies.Html do
  @moduledoc """
  Create a watermark by using a HTML intermediate step. Allows control of the
  layout via HTML and CSS.
  """
  @behaviour WatermarkBehaviour
  @wkhtmltopdf_path System.find_executable("wkhtmltopdf")
  @template "apps/watermark/lib/layouts/template.html.eex"
  @default_opts ["-q", "-g", "--no-background", "--no-images", "--disable-external-links", "--disable-javascript"]

  def new(text) when is_binary(text) do
    text
    |> make_html(output_path: System.tmp_dir!() <> "#{text}.html")
    |> html_to_pdf(output_path: "#{System.tmp_dir!()}/#{String.replace(text, ~r/\s/, "")}.pdf")
  end

  defp make_html(text, output_path: output_path) when is_binary(text) do
    {:ok, _} = File.open(output_path, [:write], fn f ->
      IO.write(f, EEx.eval_file(@template, text: text))
    end)
    output_path
  end

  defp html_to_pdf(html_path, output_path: output_path) do
    %Porcelain.Result{err: nil, out: "", status: 0} = Porcelain.exec(@wkhtmltopdf_path, @default_opts ++ [html_path, output_path] )
    output_path
  end
end
