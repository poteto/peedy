# Peedy

PDF watermarking microservice.

## Installation

```
$ mix do deps.get, deps.compile
$ mix ecto.setup
$ yarn install # or npm install
```

## Dependencies

These must be installed:

- `pdftk`: https://www.pdflabs.com/tools/pdftk-server/
- `node`: `^6.6.0`
- `yarn` or `npm`

Watermark PDFs are generated via [PDFKit](http://pdfkit.org/) in a node.js script. Type `node node_modules/peedy-stamp --help` for options.

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

## Tests

Run tests using `mix test`.

# License

Mostly MIT. PDFtk used with its [GPL](https://www.pdflabs.com/docs/pdftk-license/gnu_general_public_license_2.txt) license. To use commercially you will need to acquire a [commercial license](https://www.pdflabs.com/docs/pdftk-license/) from
PDFtk.
