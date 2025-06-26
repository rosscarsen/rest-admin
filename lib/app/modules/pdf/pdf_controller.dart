import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../config.dart';
import '../../model/print_barcode_model.dart';
import '../../service/dio_api_client.dart';
import '../../service/dio_api_result.dart';
import '../../translations/locale_keys.dart';
import '../../utils/easy_loading.dart';

class PdfController extends GetxController {
  final isLoading = true.obs;
  final ApiClient apiClient = ApiClient();

  // 页面宽度
  double PageWidth = PdfPageFormat.a4.width;

  // 页面标题
  final _title = ''.obs;
  String get title => _title.value;
  set title(String value) => _title.value = value;

  // 是否有数据
  final hasData = false.obs;

  // pdf名称
  final pdfName = 'pdf.pdf'.obs;

  // 条码数据
  List<PrintBarcodeApiResult> barcodeData = [];

  // 通用 PDF 生成函数（UI层统一调用）
  late Future<Uint8List> Function() generatePdf;

  @override
  void onInit() {
    super.onInit();

    final Map<String, String?> parameters = Get.parameters;

    switch (parameters['type']) {
      case "masterPrintBarcode":
        title = LocaleKeys.printBarcode.tr;
        PageWidth = 230;
        pdfName.value = 'barcode_${DateTime.now().millisecondsSinceEpoch}.pdf';
        getProductBarcodeData(parameters);
        generatePdf = () => generateBarcodePdf();
        break;

      default:
        title = LocaleKeys.unknown.tr;
        generatePdf = () async => Uint8List(0); // 防止UI中调用时报错
        break;
    }
  }

  /// 获取barcode数据
  Future<void> getProductBarcodeData(Map<String, String?> parameters) async {
    parameters.remove("type");
    try {
      isLoading.value = true;
      showLoading(LocaleKeys.gettingData.tr);

      final DioApiResult dioApiResult = await apiClient.post(Config.printBarcode, queryParameters: parameters);
      if (!dioApiResult.success) {
        errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }
      if (!dioApiResult.hasPermission) {
        errorMessages(dioApiResult.error ?? LocaleKeys.noPermission.tr);
        return;
      }
      if (dioApiResult.data == null) {
        showToast(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return;
      }
      final PrintBarcodeModel printBarcodeModel = printBarcodeModelFromJson(dioApiResult.data!);
      if (printBarcodeModel.status == 200) {
        barcodeData = printBarcodeModel.apiResult ?? [];
        hasData.value = barcodeData.isNotEmpty;
      } else {
        errorMessages(printBarcodeModel.msg ?? LocaleKeys.getDataException.tr);
      }
    } finally {
      dismissLoading();
      isLoading.value = false;
    }
  }

  /// 生成条码 PDF
  Future<Uint8List> generateBarcodePdf({
    double pdfHeight = 19, // mm
    double pdfWidth = 48, // mm
    double margin = 1,
    double barcodeWidth = 35,
    double barcodeHeight = 6,
  }) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.notoSansSCRegular();
    final Map<String, String?> parameters = Get.parameters;
    final showPrice = parameters["printPrice"] == "1";

    for (var item in barcodeData) {
      pdf.addPage(
        pw.Page(
          pageTheme: pw.PageTheme(
            pageFormat: PdfPageFormat(pdfWidth * PdfPageFormat.mm, pdfHeight * PdfPageFormat.mm),
            margin: pw.EdgeInsets.all(margin * PdfPageFormat.mm),
            theme: pw.ThemeData.withFont(base: font, bold: font, italic: font),
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

  @override
  void onClose() {
    super.onClose();
  }
}
