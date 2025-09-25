part of 'pdf_controller.dart';

/// 生成供应商发票 PDF
Future<Uint8List> generateSupplierInvoicePdf({
  required SupplierInvoiceApiResult data,
  required pw.ThemeData theme,
  required PdfPageFormat pdfPageFormat,
  pw.Widget? header,
}) async {
  final pdf = pw.Document();
  final Company? company = data.company;
  final Invoice? invoice = data.invoice;
  final SupplierData? supplier = data.supplier;
  final List<InvoiceDetail>? invoiceDetail = data.invoiceDetail;

  pw.ImageProvider imageProvider;
  if (company?.mLogoPath != null && company!.mLogoPath!.isNotEmpty) {
    imageProvider = await networkImage(company.mLogoPath!);
  } else {
    final bytes = await rootBundle.load('assets/companyLogo.png');
    imageProvider = pw.MemoryImage(bytes.buffer.asUint8List());
  }
  final amountStr = invoice?.mAmount ?? "0.00";
  final exRatioStr = invoice?.mExRatio ?? "0.00";

  final amount = double.tryParse(amountStr) ?? 0.0;
  final exRatio = double.tryParse(exRatioStr) ?? 0.0;

  final totalAmount = (amount * exRatio).toStringAsFixed(2);
  pdf.addPage(
    pw.MultiPage(
      pageTheme: pw.PageTheme(pageFormat: pdfPageFormat, theme: theme, margin: pw.EdgeInsets.all(10)),
      header: (context) => pw.Column(
        children: [
          buildHeader(context, company, imageProvider, LocaleKeys.supplierInvoice.tr),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Container(
                  padding: pw.EdgeInsets.all(5),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey600),
                    borderRadius: pw.BorderRadius.circular(2),
                  ),
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("${LocaleKeys.toMessrs.tr}: ${supplier?.mSimpleName ?? ""}(${supplier?.mCode ?? ""})"),
                      pw.Container(alignment: pw.Alignment.topLeft, child: pw.Text(supplier?.mAddress ?? "")),
                      pw.Row(
                        children: [
                          pw.Expanded(child: pw.Text("${LocaleKeys.mobile.tr}: ${supplier?.mPhoneNo ?? ""}")),
                          pw.Expanded(child: pw.Text("${LocaleKeys.fax.tr}: ${supplier?.mFaxNo ?? ""}")),
                        ],
                      ),
                      pw.Text("${LocaleKeys.name.tr}: ${supplier?.mContact ?? ""}"),
                    ],
                  ),
                ),
              ),
              pw.SizedBox(width: 10),
              pw.Expanded(
                child: pw.Padding(
                  padding: pw.EdgeInsets.all(5),
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("${LocaleKeys.invoiceNo.tr}: ${invoice?.mSupplierInvoiceInNo ?? ""}"),
                      pw.Text("${LocaleKeys.date.tr}: ${invoice?.mCreatedDate ?? ""}"),
                      pw.Text("${LocaleKeys.currency.tr}: ${invoice?.mMoneyCurrency ?? ""}"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      footer: (context) {
        return buildFooter(context);
      },

      build: (context) => [
        pw.TableHelper.fromTextArray(
          border: null,
          cellAlignment: pw.Alignment.centerLeft,
          headerDecoration: buildHeaderDecoration(),
          headerHeight: 25,
          cellHeight: 40,
          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.centerLeft,
            2: pw.Alignment.center,
            3: pw.Alignment.center,
            4: pw.Alignment.center,
            5: pw.Alignment.centerRight,
          },
          columnWidths: {
            0: pw.FixedColumnWidth(40),
            1: pw.FlexColumnWidth(),
            2: pw.FixedColumnWidth(100),
            3: pw.FixedColumnWidth(60),
            4: pw.FixedColumnWidth(60),
            5: pw.FixedColumnWidth(100),
          },
          headerStyle: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          cellStyle: const pw.TextStyle(fontSize: 10),
          headers: [
            LocaleKeys.item.tr,
            "${LocaleKeys.paramCode.trArgs([LocaleKeys.product.tr])}\n${LocaleKeys.description.tr}",
            "${LocaleKeys.qty.tr}\n${LocaleKeys.unit.tr}",
            LocaleKeys.unitPrice.tr,
            LocaleKeys.discount.tr,
            LocaleKeys.amount.tr,
          ],
          data:
              invoiceDetail
                  ?.map(
                    (e) => [
                      e.mItem ?? "",
                      "${e.mProductCode ?? " "}\n${e.mProductName ?? " "}",
                      "${e.mQty ?? ""}\n${e.mUnit ?? ""}",
                      e.mPrice ?? "",
                      e.mDiscount ?? "",
                      e.mAmount ?? "",
                    ],
                  )
                  .toList() ??
              [],
        ),
        buildDivider(),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("${LocaleKeys.remarks.tr}: ${invoice?.mRemarks ?? ""}"),
                  pw.SizedBox(height: 5),
                  pw.Text("${LocaleKeys.remarks.tr}: ${company?.mSupplierInvoiceTerms ?? ""}"),
                ],
              ),
            ),
            pw.SizedBox(
              width: 160,
              child: pw.Column(
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [pw.Text("${LocaleKeys.subTotal.tr}:"), pw.Text(invoice?.mAmount ?? "")],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [pw.Text("${LocaleKeys.total.tr}:"), pw.Text(totalAmount)],
                  ),
                ],
              ),
            ),
          ],
        ),
        pw.Spacer(),
        pw.DefaultTextStyle(
          style: const pw.TextStyle(fontSize: 8),
          child: pw.Column(
            children: [
              pw.Row(
                children: [
                  pw.Expanded(child: pw.Text("Confirmed & Accepted By:")),
                  pw.SizedBox(width: 40),
                  pw.Expanded(child: pw.Text("For & On Behalf Of:")),
                ],
              ),
              pw.SizedBox(height: 40),
              pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [buildDivider(), pw.Text("Authorized Signature & Chop")],
                    ),
                  ),
                  pw.SizedBox(width: 40),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [buildDivider(), pw.Text("Authorized Signature & Chop")],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
  return pdf.save();
}
