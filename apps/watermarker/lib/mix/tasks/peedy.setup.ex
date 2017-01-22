defmodule Mix.Tasks.Peedy.Setup do
  use Mix.Task

  @shortdoc "Installs the `peedy-stamp` npm package"

  def run(version \\ "1.0.0") do
    System.cmd("npm", ["i", "peedy-stamp@#{version}"])
  end
end