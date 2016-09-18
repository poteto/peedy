defmodule Stamper.Case do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Stamper.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
    end
  end

  setup tags do
    opts = tags |> Map.take([:isolation]) |> Enum.to_list()
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Stamper.Repo, opts)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Stamper.Repo, {:shared, self()})
    end

    :ok
  end
end
