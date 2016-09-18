# Watermark

Creates a watermark file to be used as a stamp.

## Installation

First, clone `dev.example.exs` and `test.example.exs` and update accordingly. Then remove `example` from the filename so you have `dev.exs` and `test.exs` defined.

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `watermark` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:watermark, "~> 0.1.0"}]
    end
    ```

  2. Ensure `watermark` is started before your application:

    ```elixir
    def application do
      [applications: [:watermark]]
    end
    ```

