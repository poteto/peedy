defmodule PeedyWeb.CallbackClientTest do
  use PeedyWeb.Case
  alias Stamper.{Repo,Document}
  alias PeedyWeb.CallbackClient

  defmodule DummyAdapter do
    def post(_, _, _), do: :ok
  end

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
    %Document{} = document = CallbackClient.perform(callback_url: "/foo", file: "foo.pdf", id: uuid, headers: %{}, adapter: DummyAdapter)

    assert document.id == uuid
  end
end
