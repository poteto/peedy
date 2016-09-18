# Peedy

![](logo/peedy.png)

Distributed PDF processing.

## Dependencies

These must be installed.

- `pdftk`: https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk_server-2.02-mac_osx-10.11-setup.pkg
- `wkhtmltopdf`: http://download.gna.org/wkhtmltopdf/0.12/0.12.3/wkhtmltox-0.12.3_osx-cocoa-x86-64.pkg

## Installation

```
$ mix do deps.get, deps.compile
$ mix ecto.setup
```

## Examples

Start your IEx console with the `Peedy` app:

```
$ iex -S mix
```

Generate an ephemeral watermarked document, with the default callback:

```elixir
iex(1)> Peedy.F.watermark("Ricky Bobby", input_path: "samples/bible.pdf", ephemeral?: true)
```

Generate a persisted watermarked document, with custom callback:

```elixir
iex(1)> custom_callback = fn doc -> IO.puts("id is " <> doc.id) end
iex(2)> Peedy.F.watermark("Ricky Bobby", custom_callback, input_path: "samples/bible.pdf", ephemeral?: false)
```

## Tests

Run tests using `mix test`.
