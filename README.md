# Peedy

![](logo/peedy.png)

Distributed PDF processing.

## Dependencies

These must be installed.

`pdftk` - https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk_server-2.02-mac_osx-10.11-setup.pkg
`wkhtmltopdf` - http://download.gna.org/wkhtmltopdf/0.12/0.12.3/wkhtmltox-0.12.3_osx-cocoa-x86-64.pkg

## Examples

In your IEx console:

```
$ iex -S mix
```

```elixir
iex(1)> Watermark.Strategies.Html.new("Ricky Bobby") |> Stamp.stamp_with(input_path: "samples/pride_and_prejudice.pdf", output_path: "out.pdf")
```
