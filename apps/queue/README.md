# Queue

Very simple queue example with rate limiting.

## Usage

```elixir
1..100
|> Enum.map(fn i -> "Job number: #{i}" end)
|> Queue.enqueue_all()
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `queue` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:queue, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/queue](https://hexdocs.pm/queue).

