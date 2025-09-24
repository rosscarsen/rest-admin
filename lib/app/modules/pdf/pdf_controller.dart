import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../config.dart';
import '../../model/product/print_barcode_model.dart';
import '../../service/dio_api_client.dart';
import '../../service/dio_api_result.dart';
import '../../translations/locale_keys.dart';
import '../../utils/custom_dialog.dart';
import 'model/supplier_invoice_api_model.dart';

class PdfController extends GetxController {
  final isLoading = true.obs;
  final ApiClient apiClient = ApiClient();
  // pdf页面大小
  PdfPageFormat pdfPageFormat = PdfPageFormat.a4;

  /// 最大宽度
  double maxPageWidth = 700.00;
  // 页面标题
  final _title = ''.obs;
  String get title => _title.value;
  set title(String value) => _title.value = value;

  // 是否有数据
  final hasData = false.obs;

  // pdf名称
  String pdfName = 'pdf.pdf';

  late pw.ThemeData theme;
  // 通用 PDF 生成函数（UI层统一调用）
  late Future<Uint8List> Function() generatePdf;

  @override
  void onInit() async {
    super.onInit();
    await initTheme();
    final Map<String, String?> parameters = Get.parameters;
    final String? type = parameters['type'];
    pdfName = '${type ?? 'pdf'}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    switch (type) {
      case "barcode": //食品主档打印条码
        title = LocaleKeys.printBarcode.tr;
        pdfPageFormat = PdfPageFormat(48 * PdfPageFormat.mm, 19 * PdfPageFormat.mm);
        maxPageWidth = 230;
        getProductBarcodeData(parameters).then((value) {
          if (value != null) {
            hasData.value = value.isNotEmpty;
            generatePdf = () => generateBarcodePdf(barcodeData: value);
          }
        });
        break;
      case "supplierInvoice":
        title = LocaleKeys.supplierInvoice.tr;
        getSupplierInvoiceData(parameters).then((value) {
          if (value != null) {
            hasData.value = true;
            generatePdf = () => generateSupplierInvoicePdf(data: value);
          }
        });
        break;
      default:
        title = LocaleKeys.unknown.tr;
        generatePdf = () async => Uint8List(0); // 防止UI中调用时报错
        break;
    }
  }

  /// 初始pdf theme
  Future<void> initTheme() async {
    final baseFont = await PdfGoogleFonts.notoSansSCRegular();
    // 加入一个英文字体作为 fallback，或者再加 emoji 字体
    final fallbackFont = await PdfGoogleFonts.notoSansSymbols2Regular();

    theme = pw.ThemeData.withFont(base: baseFont, bold: baseFont, italic: baseFont, icons: baseFont).copyWith(
      defaultTextStyle: pw.TextStyle(font: baseFont, fontFallback: [fallbackFont]),
    );
  }

  /// 获取barcode数据
  Future<List<PrintBarcodeApiResult>?> getProductBarcodeData(Map<String, String?> parameters) async {
    try {
      isLoading.value = true;
      final DioApiResult dioApiResult = await apiClient.post(Config.printBarcode, queryParameters: parameters);
      if (!dioApiResult.success) {
        CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return null;
      }
      if (!dioApiResult.hasPermission) {
        CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.noPermission.tr);
        return null;
      }
      if (dioApiResult.data == null) {
        CustomDialog.showToast(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return null;
      }
      final PrintBarcodeModel printBarcodeModel = printBarcodeModelFromJson(dioApiResult.data!);
      if (printBarcodeModel.status == 200) {
        return printBarcodeModel.apiResult;
      } else {
        CustomDialog.errorMessages(printBarcodeModel.msg ?? LocaleKeys.getDataException.tr);
        return null;
      }
    } finally {
      CustomDialog.dismissDialog();
      isLoading.value = false;
    }
  }

  /// 生成条码 PDF
  Future<Uint8List> generateBarcodePdf({
    required List<PrintBarcodeApiResult> barcodeData,
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

  /// 获取供应商发票数据
  Future<SupplierInvoiceApiResult?> getSupplierInvoiceData(Map<String, String?> parameters) async {
    try {
      isLoading.value = true;
      CustomDialog.showLoading(LocaleKeys.gettingData.tr);
      final DioApiResult dioApiResult = await apiClient.get(Config.getSupplierInvoicePdf, queryParameters: parameters);
      if (!dioApiResult.success) {
        CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return null;
      }
      if (!dioApiResult.hasPermission) {
        CustomDialog.errorMessages(dioApiResult.error ?? LocaleKeys.noPermission.tr);
        return null;
      }
      if (dioApiResult.data == null) {
        CustomDialog.showToast(dioApiResult.error ?? LocaleKeys.unknownError.tr);
        return null;
      }
      final retModel = supplierInvoiceApiModelFromJson(dioApiResult.data!);
      if (retModel.status == 200) {
        return retModel.apiResult;
      } else if (retModel.status == 201) {
        CustomDialog.errorMessages(retModel.msg ?? LocaleKeys.getDataException.tr);
        return null;
      } else {
        CustomDialog.errorMessages(retModel.msg ?? LocaleKeys.getDataException.tr);
        return null;
      }
    } finally {
      CustomDialog.dismissDialog();
      isLoading.value = false;
    }
  }

  /// 生成供应商发票 PDF
  Future<Uint8List> generateSupplierInvoicePdf({required SupplierInvoiceApiResult data}) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.notoSansSCRegular();
    final company = data.company;
    final invoice = data.invoice;
    final supplier = data.supplier; //重写供应商model

    return pdf.save();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
