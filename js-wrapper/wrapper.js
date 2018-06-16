const pdfium = require('../dist/pdfium');
const fs = require('fs');
const path = require('path');

FPDF_InitLibrary = pdfium.cwrap('FPDF_InitLibrary');
createDocFromBuffer = pdfium.cwrap('createDocFromBuffer', 'number', ['number', 'number']);
FPDFAvail_GetDocument = pdfium.cwrap('FPDFAvail_GetDocument', 'number', ['number', 'number']);
FPDF_GetPageCount = pdfium.cwrap('FPDF_GetPageCount', 'number', ['number']);
FPDF_CloseDocument = pdfium.cwrap('FPDF_CloseDocument', '', ['number']);
FPDFAvail_Destroy = pdfium.cwrap('FPDFAvail_Destroy', '', ['number']);
FPDF_DestroyLibrary = pdfium.cwrap('FPDF_DestroyLibrary');

const inputFile = path.join(__dirname, 'web-assembly.pdf');

function pageSize() {
    console.log('File:', inputFile);
    FPDF_InitLibrary();
    const buffer = fs.readFileSync(inputFile);
    const wasmBuffer = pdfium._malloc(buffer.length);
    pdfium.HEAPU8.set(buffer, wasmBuffer);
    const pdfAvail = createDocFromBuffer(wasmBuffer, buffer.length);
    const doc = FPDFAvail_GetDocument(pdfAvail, null);
    console.log('Pages', FPDF_GetPageCount(doc));
    FPDF_CloseDocument(doc);
    FPDFAvail_Destroy(pdfAvail);
    FPDF_DestroyLibrary();
}

setTimeout(() => pageSize(), 2000);
