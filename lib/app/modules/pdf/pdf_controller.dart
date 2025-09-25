import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../config.dart';
import '../../model/company/company_model.dart';
import '../../model/product/print_barcode_model.dart';
import '../../model/supplier/supplier_data.dart';
import '../../service/dio_api_client.dart';
import '../../service/dio_api_result.dart';
import '../../service/pdf_theme_manager.dart';
import '../../translations/locale_keys.dart';
import '../../utils/custom_dialog.dart';
import '../../utils/logger.dart';
import 'common.dart';
import 'model/supplier_invoice_api_model.dart';
part 'barcode_pdf.dart';
part 'supplier_invoice_pdf.dart';

class PdfController extends GetxController {
  final isLoading = true.obs;
  final ApiClient apiClient = ApiClient();
  // pdf页面大小
  PdfPageFormat pdfPageFormat = PdfPageFormat.a4;

  /// 最大宽度
  double maxPageWidth = 800.00;
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
            generatePdf = () => generateBarcodePdf(barcodeData: value, theme: theme, pdfPageFormat: pdfPageFormat);
          }
        });
        break;
      case "supplierInvoice":
        title = LocaleKeys.supplierInvoice.tr;
        getSupplierInvoiceData(parameters).then((value) {
          if (value != null) {
            hasData.value = true;
            generatePdf = () => generateSupplierInvoicePdf(data: value, theme: theme, pdfPageFormat: pdfPageFormat);
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
    theme = await PdfThemeManager.instance.getTheme();
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

  /// PDF 头
  pw.Widget _buildHeader(pw.Context context, Company? company, pw.ImageProvider imageProvider, String title) {
    return pw.Column(
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Container(
              alignment: pw.Alignment.center,
              width: 80,
              height: 80,
              decoration: pw.BoxDecoration(
                image: pw.DecorationImage(image: imageProvider, fit: pw.BoxFit.contain),
              ),
            ),
            pw.Expanded(
              child: pw.Padding(
                padding: pw.EdgeInsets.only(left: 8),
                child: pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(company?.mNameChinese ?? "", style: pw.TextStyle(fontSize: 16)),
                    pw.Text(company?.mNameEnglish ?? "", style: pw.TextStyle(fontSize: 16)),
                    pw.Divider(color: PdfColors.grey700),
                    pw.Text(company?.mAddress ?? ""),
                    pw.Row(
                      children: [
                        pw.Expanded(child: pw.Text("${LocaleKeys.tel.tr}: ${company?.mTel ?? ""}")),
                        pw.Expanded(child: pw.Text("${LocaleKeys.fax.tr}: ${company?.mFax ?? ""}")),
                      ],
                    ),
                    pw.Row(
                      children: [
                        pw.Expanded(child: pw.Text("${LocaleKeys.email.tr}: ${company?.mEMail ?? ""}")),
                        pw.Expanded(
                          child: pw.FittedBox(child: pw.Text("${LocaleKeys.website.tr}: ${company?.mWebSite ?? ""}")),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        pw.Text(title, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        if (context.pageNumber > 1) pw.SizedBox(height: 10),
        if (context.pageNumber > 1) pw.SizedBox(height: 10),
      ],
    );
  }

  @override
  void onClose() {
    super.onClose();
  }
}
