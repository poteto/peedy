defmodule PeedyWeb.Api.V1.DocumentController do
  use PeedyWeb.Web, :controller
  alias Stamper.{Repo,Document}
  alias PeedyWeb.ErrorView

  @callback_client Application.get_env(:peedy_web, :callback_client)
  @whitelisted_content_types MapSet.new(~w(application/pdf))
  @document_headers %{
    "Content-Type" => "multipart/form-data"
  }

  def show(conn, %{"id" => id}) do
    case Repo.get(Document, id) do
      %Document{id: id, output: output} ->
        filename = "#{id}.pdf"
        tmp_path = System.tmp_dir!() <> filename
        attachment = File.write!(tmp_path, output)

        conn
        |> put_resp_header("content-disposition", ~s(attachment; filename="#{filename}"))
        |> Plug.Conn.send_file(:ok, tmp_path)
      _ ->
        conn
        |> halt()
        |> put_status(:not_found)
        |> render(ErrorView, "404.json", %{detail: "Invalid id"})
    end
  end

  def create(conn, %{"watermark" => watermark_text, "callback_url" => callback_url} = params) do
    params
    |> Map.drop(["watermark", "callback_url"])
    |> Map.values()
    |> whitelist_content_type()
    |> case do
      [] ->
        conn
        |> halt()
        |> put_status(:bad_request)
        |> render(ErrorView, "400.json", %{detail: "No PDFs received"})
      files ->
        watermark = Watermarker.create(watermark_text)
        Enum.map(files, fn %Plug.Upload{filename: filename, path: path} ->
          Peedy.F.watermark_with(watermark, &(create_callback(&1, filename, callback_url)), input_path: path, ephemeral?: false)
        end)

        send_resp(conn, :ok, "OK")
      end
  end
  def create(conn, _) do
    conn
    |> halt()
    |> put_status(:bad_request)
    |> render(ErrorView, "400.json", %{detail: "Watermark and/or callback_url are missing"})
  end

  defp create_callback(%Document{id: id, output: output}, filename, callback_url) do
    file_path = System.tmp_dir!() <> Zarex.sanitize(filename)
    File.write!(file_path, output)
    @callback_client.do_callback(callback_url, %{file: file_path, id: id}, @document_headers)
  end

  defp whitelist_content_type(uploads) when is_list(uploads) do
    Enum.filter(uploads, fn %Plug.Upload{content_type: content_type} ->
      MapSet.member?(@whitelisted_content_types, content_type)
    end)
  end
end
