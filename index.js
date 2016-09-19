/* jshint node:true, esversion:6 */
/* global require, module */
const PDFDocument = require('pdfkit');
const blobStream = require('blob-stream');
const fs = require('fs');
const os = require('os');
const program = require('commander');

function calculateFontSize(textLength, width, height) {
  return (height / textLength) * (height * 1.1 / width);
}

function sanitizeText(text = '') {
  return text.replace('@', '_');
}

program
  .version('1.0.0')
  .option('-t, --text <value>', 'Text to be rendered')
  .option('-o, --output <value>', 'Output path')
  .option('-h, --header', 'Show header?')
  .parse(process.argv);

let doc = new PDFDocument({ margin: 0 });
doc.pipe(fs.createWriteStream(program.output));
let saved = doc.save(); // save stack so we can un-rotate later using `restore`

let halfWidth = doc.page.width / 2;
let halfHeight = doc.page.height / 2;
let text = sanitizeText(program.text);

doc
  .font('Helvetica')
  .fontSize(calculateFontSize(program.text.length, doc.page.width, doc.page.height))
  .rotate(50, {
    origin: [halfWidth, halfHeight]
  })
  .fillOpacity(0.2)
  .text(text, 0, halfHeight, {
    width: doc.page.width,
    align: 'center',
    continued: false
  });

if (program.header) {
  doc
    .restore()
    .moveDown()
    .font('Helvetica')
    .fontSize(25)
    .fillOpacity(0.2)
    .text(text, 0, 100, {
      width: doc.page.width,
      align: 'center'
    });
}

doc.end();

process.stdout.write(program.output);
process.stdout.on('error', function({ code }) {
  if (code === 'EPIPE') {
    process.exit(0);
  }
});
