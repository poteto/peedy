defmodule Stamper do
  use Application
  require Logger
  alias Stamper.{Repo,Document}
  alias Watermarker.Watermark

  @after_compile __MODULE__
  @pdftk Application.get_env(:stamper, :executables)[:pdftk]

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      worker(Stamper.Repo, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Stamper.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def stamp_with(%Watermark{id: id} = watermark, input_path: input_path, ephemeral?: true) do
    output_path = stamp_document(watermark, input_path)
    input = File.read!(input_path)
    output = File.read!(output_path)

    %Document{
      input: input,
      input_hash: Document.calculate_binary_hash(input),
      output: output,
      output_hash: Document.calculate_binary_hash(output),
      stamp_id: id,
      ephemeral?: true
    }
  end
  def stamp_with(%Watermark{id: id} = watermark, input_path: input_path, ephemeral?: false) do
    output_path = stamp_document(watermark, input_path)

    %Document{}
    |> Document.changeset(%{
        input: File.read!(input_path),
        output: File.read!(output_path),
        stamp_id: id})
    |> Repo.insert!()
  end

  defp stamp_path(%Watermark{id: id, output: output}) do
    stamp_path = System.tmp_dir!() <> "#{id}.pdf"
    :ok = File.write!(stamp_path, output)
    stamp_path
  end

  defp random_string(length \\ 64) do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, length)
  end

  defp stamp_document(%Watermark{} = watermark, input_path) do
    output_path = System.tmp_dir!() <> "#{random_string()}.pdf"
    stamp_path = stamp_path(watermark)
    %Porcelain.Result{err: nil, out: "", status: 0} = Porcelain.exec(@pdftk, [input_path, "multistamp", stamp_path, "output", output_path])
    output_path
  end

  def __after_compile__(_env, _bytecode) do
    if is_nil(@pdftk), do: raise error_msg("pdftk")
  end

  defp error_msg(missing) do
    "Missing executable for `#{missing}`. Ensure it is installed."
  end
end
