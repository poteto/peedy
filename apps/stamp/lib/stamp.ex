defmodule Stamp do
  require Logger

  @pdftk_path System.find_executable("pdftk")

  def stamp_with(stamp_path, input_path: input_path, output_path: output_path) do
    cond do
      File.exists?(stamp_path) ->
        %Porcelain.Result{err: nil, out: "", status: 0} = Porcelain.exec(@pdftk_path, [input_path, "multistamp", stamp_path, "output", output_path])
        output_path
      true -> raise "Could not find stamp"
    end
  end
end
