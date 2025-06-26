import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../translations/locale_keys.dart';
import '../../utils/file_storage.dart';
import 'pdf_controller.dart';

class PdfView extends GetView<PdfController> {
  const PdfView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: Text(controller.title),
          centerTitle: true,
          actions: controller.hasData.value
              ? [
                  // 打印按钮
                  Tooltip(
                    message: LocaleKeys.print.tr,
                    child: IconButton(
                      onPressed: () async {
                        final pdfBytes = await controller.generatePdf();
                        await Printing.layoutPdf(
                          onLayout: (PdfPageFormat format) async => pdfBytes,
                          name: controller.pdfName.value,
                        );
                      },
                      icon: const Icon(Icons.print),
                    ),
                  ),
                  // 分享按钮
                  Tooltip(
                    message: LocaleKeys.share.tr,
                    child: IconButton(
                      onPressed: () async {
                        final pdfBytes = await controller.generatePdf();
                        await Printing.sharePdf(bytes: pdfBytes, filename: controller.pdfName.value);
                      },
                      icon: const Icon(Icons.share),
                    ),
                  ),
                  // 下载按钮
                  Tooltip(
                    message: LocaleKeys.download.tr,
                    child: IconButton(
                      onPressed: () async {
                        final pdfBytes = await controller.generatePdf();
                        await FileStorage.saveFileToDownloads(
                          bytes: pdfBytes,
                          fileName: controller.pdfName.value,
                          fileType: DownloadFileType.Pdf,
                        );
                      },
                      icon: const Icon(Icons.download),
                    ),
                  ),
                ]
              : null,
        ),
        body: controller.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : controller.hasData.value
            ? PdfPreview(
                initialPageFormat: PdfPageFormat(48 * PdfPageFormat.mm, 19 * PdfPageFormat.mm),
                build: (format) => controller.generateBarcodePdf(),
                maxPageWidth: controller.PageWidth,
                useActions: false,
              )
            : Center(child: Text(LocaleKeys.noRecordFound.tr, style: const TextStyle(fontSize: 20))),
      );
    });
  }

  /* Future<Uint8List> generateBarcodePdf({
    required List<Map<String, dynamic>> items,
    double pdfHeight = 19, // mm
    double pdfWidth = 48, // mm
    double margin = 1,
    double barcodeWidth = 35,
    double barcodeHeight = 6,
    bool showPrice = true,
  }) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.notoSansSCRegular(); // 中文字体

    for (var item in items) {
      pdf.addPage(
        pw.Page(
          pageTheme: pw.PageTheme(
            pageFormat: PdfPageFormat(pdfWidth * PdfPageFormat.mm, pdfHeight * PdfPageFormat.mm),
            margin: pw.EdgeInsets.all(margin * PdfPageFormat.mm),
            theme: pw.ThemeData.withFont(base: font, bold: font, italic: font),
          ),
          build:
              (context) => pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(item['mName'], style: pw.TextStyle(fontSize: 8)),
                  pw.SizedBox(height: 2),
                  pw.BarcodeWidget(
                    barcode: pw.Barcode.code128(),
                    data: item['mCode'],
                    drawText: false,
                    width: barcodeWidth * PdfPageFormat.mm,
                    height: barcodeHeight * PdfPageFormat.mm,
                  ),

                  pw.SizedBox(height: 2),
                  pw.Text(
                    '${item['mCode']}${showPrice ? '   \$${item['mPrice']}' : ''}',
                    style: pw.TextStyle(fontSize: 8),
                  ),
                ],
              ),
        ),
      );
    }
    return pdf.save();
  } */

  /* Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          orientation: pw.PageOrientation.landscape,
          pageFormat: PdfPageFormat(
            PdfPageFormat.a4.width,
            PdfPageFormat.a4.height,
            marginLeft: 16,
            marginRight: 16,
            marginTop: 16,
            marginBottom: 32,
          ),
          margin: pw.EdgeInsets.all(16),
          theme: pw.ThemeData.withFont(base: await PdfGoogleFonts.notoSansSCRegular()),
        ),
        footer: (pw.Context context) {
          return pw.SizedBox(
            width: double.infinity,
            child: pw.Text(
              'Page ${context.pageNumber}/${context.pagesCount}',
              style: const pw.TextStyle(color: PdfColors.black),
              textAlign: pw.TextAlign.right,
            ),
          );
        },
        build: (context) {
          return [
            pw.Text('你好，世界！这是一个测试 PDF 文档', style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 20),
            pw.Container(width: 100, height: 100, child: pw.FlutterLogo()),

            pw.SizedBox(height: 20),

            // 多段自动分页内容
            ...List.generate(
              300,
              (i) => pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 4),
                child: pw.Text('这是第 ${i + 1} 段内容，自动分页处理。', style: pw.TextStyle(fontSize: 14)),
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }
 */
  /* Future<Uint8List> generateSalesReportPdf() async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final pdfFont = await PdfGoogleFonts.notoSansSCRegular();
    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(16),
          theme: pw.ThemeData.withFont(base: pdfFont),
        ),
        build:
            (context) => [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('[RPT00A]', style: pw.TextStyle(fontSize: 12)),
                      pw.SizedBox(height: 8),
                      pw.Text('编号：'),
                      pw.Text('打印时间：2025-04-30 14:56'),
                      pw.Text('发票总数：0'),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text('百怡富科技', style: pw.TextStyle(fontSize: 16)),
                      pw.Text('[RPT00] 销售报表', style: pw.TextStyle(fontSize: 12)),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [pw.Text('日期：2025-04-30 ~ 2025-04-30'), pw.Text('收银机：')],
                  ),
                ],
              ),
              pw.SizedBox(height: 12),
              pw.Divider(),
              pw.TableHelper.fromTextArray(
                border: null,
                cellAlignment: pw.Alignment.centerLeft,
                headerDecoration: pw.BoxDecoration(
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
                  color: PdfColors.teal,
                ),
                headerHeight: 25,
                cellHeight: 40,
                columnWidths: {
                  0: pw.FixedColumnWidth(300),
                  1: pw.FixedColumnWidth(50),
                  2: pw.FixedColumnWidth(50),
                  3: pw.FixedColumnWidth(50),
                  4: pw.FixedColumnWidth(50),
                  5: pw.FixedColumnWidth(50),
                  6: pw.FixedColumnWidth(50),
                },
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.centerRight,
                  3: pw.Alignment.center,
                  4: pw.Alignment.centerRight,
                },
                headerStyle: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  font: pdfFont,
                ),
                cellStyle: const pw.TextStyle(color: PdfColors.blueGrey800, fontSize: 10),
                rowDecoration: pw.BoxDecoration(
                  border: pw.Border(bottom: pw.BorderSide(color: PdfColors.blueGrey900, width: .5)),
                ),
                headers: [
                  '编号',
                  '营业员',
                  '客户',
                  '金额',
                  'CASH',
                  'VISA',
                  'MASTER',
                  'POS',
                  'EPS',
                  'OCTOPUS',
                  'WECHAT',
                  'Tips',
                ],
                data: [
                  ['1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1'],
                  ['2', '2', '2', '2', '2', '2', '2', '2', '2', '2', '2', '2'],
                  ['3', '3', '3', '3', '3', '3', '3', '3', '3', '3', '3', '3'],
                ], // 可以动态填充数据
              ),
              pw.Divider(),
              pw.Row(children: [pw.Expanded(child: pw.Text('总计')), pw.Text('0.00')]),
            ],
      ),
    );

    return pdf.save();
  }
 */
}
