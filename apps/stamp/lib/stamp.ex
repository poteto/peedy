defmodule Stamp do
  require Logger

  @pdftk_path System.find_executable("pdftk")

  def stamp_with(stamp_path, input_path: input_path, output_path: output_path) do
    {microseconds, results} = :timer.tc(fn ->
      %Porcelain.Result{err: nil, out: "", status: 0} = Porcelain.exec(@pdftk_path, [input_path, "multistamp", stamp_path, "output", output_path])
      output_path
    end, [])

    Logger.info("Stamped in #{microseconds / 1_000_000}s")
    results
  end
end
