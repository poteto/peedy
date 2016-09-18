defmodule PeedyWeb.CallbackClientTest do
  use PeedyWeb.Case
  alias Stamper.{Repo,Document}
  alias PeedyWeb.CallbackClient

  setup do
    uuid = Ecto.UUID.generate()
    document =
      %Document{
        id: uuid,
        input: <<1, 2>>,
        output: <<3, 4>>,
        input_hash: "abc",
        output_hash: "def",
        stamp_id: "bar"
      }
      |> Repo.insert!()

    {:ok, %{uuid: uuid, document: document}}
  end

  test "post returns document", %{uuid: uuid} do
    %Document{} = document = CallbackClient.post("/foo", %{file: "foo.pdf", id: uuid}, %{})

    assert document.id == uuid
  end
end
