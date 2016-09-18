defmodule Watermarker.Strategies.Html do
  @moduledoc """
  Create a watermark by using a HTML intermediate step. Allows control of the
  layout via HTML and CSS.
  """
  require Logger
  alias Watermarker.{Watermark,Repo}

  @behaviour Watermarker.WatermarkerBehaviour
  @wkhtmltopdf Application.get_env(:watermarker, :executables)[:wkhtmltopdf]
  @template Application.get_env(:watermarker, :layout)
  @default_opts ~w(-q -g --no-background --no-images --disable-external-links
                   --disable-javascript)

  def new(text) when is_binary(text) do
    case Repo.get_by(Watermark, input: text) do
      %Watermark{} = watermark -> watermark
      nil ->
        tmp_dir = System.tmp_dir!()
        sanitized_text = Zarex.sanitize(text)
        output =
          text
          |> make_html(output_path: tmp_dir <> "#{sanitized_text}.html")
          |> html_to_pdf(output_path: tmp_dir <> "#{sanitized_text}.pdf")
          |> File.read!()

        %Watermark{}
        |> Watermark.changeset(%{input: text, output: output})
        |> Repo.insert!()
    end
  end

  defp make_html(text, output_path: output_path) when is_binary(text) do
    File.write!(output_path, EEx.eval_file(@template, text: text))
    output_path
  end

  defp html_to_pdf(html_path, output_path: output_path) do
    %Porcelain.Result{err: nil, out: "", status: 0} = Porcelain.exec(@wkhtmltopdf, @default_opts ++ [html_path, output_path] )
    output_path
  end
end
