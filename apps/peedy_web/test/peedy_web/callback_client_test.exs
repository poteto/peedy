defmodule PeedyWeb.CallbackClientTest do
  use PeedyWeb.Case
  alias PeedyF.{Repo, Document, Watermark}
  alias PeedyWeb.CallbackClient

  @watermark_id Ecto.UUID.generate()

  defmodule DummyAdapter do
    def post(_, _, _), do: :ok
  end

  setup do
    on_exit fn -> Toniq.failed_jobs |> Enum.map(&Toniq.delete/1) end
    uuid = Ecto.UUID.generate()
    %Watermark{id: @watermark_id, input: "Jim Bob", output: <<1, 2>>}
    |> Repo.insert!()
    document = %Document{
      id: uuid,
      input: <<1, 2>>,
      output: <<3, 4>>,
      input_hash: "abc",
      output_hash: "def",
      watermark_id: @watermark_id
    }
    |> Repo.insert!()

    {:ok, %{uuid: uuid, document: document}}
  end

  test "post returns document", %{uuid: uuid} do
    %Document{} = document = CallbackClient.perform(callback_url: "/foo", file: "foo.pdf", id: uuid, headers: %{}, adapter: DummyAdapter)

    assert document.id == uuid
  end
end
