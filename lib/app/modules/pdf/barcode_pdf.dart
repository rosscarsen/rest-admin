part of 'pdf_controller.dart';

Future<Uint8List> generateBarcodePdf({
  required List<PrintBarcodeApiResult> barcodeData,
  required pw.ThemeData theme,
  required PdfPageFormat pdfPageFormat,
  double margin = 1,
  double barcodeWidth = 35,
  double barcodeHeight = 6,
}) async {
  final pdf = pw.Document();
  final Map<String, String?> parameters = Get.parameters;
  final showPrice = parameters["printPrice"] == "1";

  for (var item in barcodeData) {
    pdf.addPage(
      pw.Page(
        pageTheme: pw.PageTheme(
          pageFormat: pdfPageFormat,
          margin: pw.EdgeInsets.all(margin * PdfPageFormat.mm),
          theme: theme,
        ),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(item.mName ?? "", style: pw.TextStyle(fontSize: 8), maxLines: 1, overflow: pw.TextOverflow.clip),
            pw.SizedBox(height: 2),
            pw.BarcodeWidget(
              barcode: pw.Barcode.code128(),
              data: item.mCode ?? "",
              drawText: false,
              width: barcodeWidth * PdfPageFormat.mm,
              height: barcodeHeight * PdfPageFormat.mm,
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              '${item.mCode ?? ""}${showPrice ? '   \$${item.mPrice ?? ""}' : ''}',
              style: pw.TextStyle(fontSize: 8),
            ),
          ],
        ),
      ),
    );
  }

  return pdf.save();
}
