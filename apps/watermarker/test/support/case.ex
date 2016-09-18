defmodule Watermarker.Case do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Watermarker.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
    end
  end

  setup tags do
    opts = tags |> Map.take([:isolation]) |> Enum.to_list()
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Watermarker.Repo, opts)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Watermarker.Repo, {:shared, self()})
    end

    :ok
  end
end
