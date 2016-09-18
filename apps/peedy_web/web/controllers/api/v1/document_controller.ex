defmodule PeedyWeb.Api.V1.DocumentController do
  use PeedyWeb.Web, :controller
  alias Stamper.{Repo,Document}
  alias PeedyWeb.ErrorView

  @callback_client Application.get_env(:peedy_web, :callback_client)
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
        |> put_status(:not_found)
        |> render(ErrorView, "404.json")
    end
  end

  def create(conn, %{"watermark" => watermark_text, "callback_url" => callback_url} = params) do
    params
    |> Map.drop(["watermark", "callback_url"])
    |> Map.values()
    |> Enum.map(fn %Plug.Upload{filename: filename, path: path} ->
      Peedy.F.watermark(watermark_text, &(create_callback(&1, filename, callback_url)), input_path: path, ephemeral?: false)
    end)

    send_resp(conn, :ok, "OK")
  end
  def create(conn, _) do
    conn
    |> put_status(:bad_request)
    |> render(ErrorView, "400.json")
  end

  defp create_callback(%Document{id: id, output: output}, filename, callback_url) do
    file_path = System.tmp_dir!() <> Zarex.sanitize(filename)
    File.write!(file_path, output)
    @callback_client.post(callback_url, %{file: file_path, id: id}, @document_headers)
  end
end
