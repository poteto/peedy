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

## Web Examples

First start the server:

```
$ mix phoenix.server
```

You can use `http://localhost:4000/api/v1/dev/null` as a valid callback_url in absence of a real one.

Upload file(s) with watermark text to:

```
POST http://localhost:4000/api/v1/documents?watermark=Ricky Bobby&callback_url=xxx
```

Attach file(s) via `form-data`. Key names are ignored.

To fetch a document by `id`:

```
GET http://localhost:4000/api/v1/documents/ebf66636-0706-4bf2-afb6-de5bc8f28688
```

You can enter this into your browser and a file download will automatically be triggered.

## CLI Examples

Start your IEx console with the `Peedy` app:

```
$ iex -S mix phoenix.server
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
