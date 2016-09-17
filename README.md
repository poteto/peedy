# Peedy

![](logo/peedy.png)

Distributed PDF processing.

## Examples

In your IEx console:

```
$ iex -S mix
```

```elixir
iex(1)> Watermark.Strategies.Html.new("Ricky Bobby") |> Stamp.stamp_with(input_path: "samples/pride_and_prejudice.pdf", output_path: "out.pdf")
"out.pdf"
````
