import 'package:get/get.dart';
import 'package:pdf/pdf.dart' show PdfColors;
import 'package:pdf/widgets.dart' as pw;

import '../../model/company/company_model.dart';
import '../../translations/locale_keys.dart';

/// PDF 头
pw.Widget buildHeader(pw.Context context, Company? company, pw.ImageProvider imageProvider, String title) {
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
                  pw.Container(margin: pw.EdgeInsets.symmetric(vertical: 5), height: 0.5, color: PdfColors.grey500),
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
      pw.Padding(
        padding: pw.EdgeInsets.symmetric(vertical: 5.0),
        child: pw.Text(title, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
      ),
    ],
  );
}

/// PDF 头装饰
pw.BoxDecoration buildHeaderDecoration() {
  return pw.BoxDecoration(
    border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey600, width: .5)),
  );
}

pw.Divider buildDivider({double? indent, double? endIndent}) {
  return pw.Divider(color: PdfColors.grey600, indent: indent, endIndent: endIndent);
}

/// PDF 页脚
pw.Widget buildFooter(pw.Context context) {
  return pw.Align(
    alignment: pw.Alignment.centerRight,
    child: pw.Text("Page ${context.pageNumber} / ${context.pagesCount}", style: pw.TextStyle(fontSize: 10)),
  );
}
