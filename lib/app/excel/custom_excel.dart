import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:get/get.dart';

import '../model/product_export_model.dart';
import '../translations/locale_keys.dart';
import '../utils/file_storage.dart';

class CustomExcel {
  static final CellStyle _headStyle = CellStyle(
    bold: true,
    textWrapping: TextWrapping.WrapText,
    horizontalAlign: HorizontalAlign.Center,
    verticalAlign: VerticalAlign.Center,
  );

  /// 获取Excel列名
  static String getExcelColumnName(int columnIndex) {
    final StringBuffer result = StringBuffer();
    while (columnIndex >= 0) {
      int remainder = columnIndex % 26;
      result.write(String.fromCharCode(65 + remainder)); // 65是'A'的ASCII码
      columnIndex = (columnIndex ~/ 26) - 1;
    }
    return result.toString().split('').reversed.join();
  }

  /// 生成Excel列名list
  static List<String> getExcelColumnNames(int columnCount) {
    final List<String> columnNames = [];
    for (int i = 0; i < columnCount; i++) {
      columnNames.add(getExcelColumnName(i));
    }
    return columnNames;
  }

  static CellValue _toCellValue(dynamic cellValue) {
    switch (cellValue) {
      case String():
        return TextCellValue(cellValue);
      case int():
        return IntCellValue(cellValue);
      case double():
        return DoubleCellValue(cellValue);
      case bool():
        return BoolCellValue(cellValue);
      case DateTime():
        final DateTime dateTime = cellValue;

        return dateTime.hour > 0 && dateTime.minute > 0
            ? DateTimeCellValue(
                year: dateTime.year,
                month: dateTime.month,
                day: dateTime.day,
                hour: dateTime.hour,
                minute: dateTime.minute,
                second: dateTime.second,
              )
            : DateCellValue(year: dateTime.year, month: dateTime.month, day: dateTime.day);
      default:
        return TextCellValue(cellValue?.toString() ?? "");
    }
  }

  static Future<void> exportProduct(List<ProductExportResult> result) async {
    final excel = Excel.createExcel();
    Sheet sheet = excel['Sheet1'];
    sheet.setRowHeight(0, 30);

    final List<String> headers = [
      "${LocaleKeys.barcode.tr}(*)",
      "${LocaleKeys.code.tr}(*)",
      LocaleKeys.unit.tr,
      LocaleKeys.name.tr,
      LocaleKeys.kitchenList.tr,
      LocaleKeys.keyName.tr,
      "${LocaleKeys.category.tr}1",
      "${LocaleKeys.category.tr}2",
      LocaleKeys.remarks.tr,
      LocaleKeys.supplier.tr,
      LocaleKeys.refCode.tr,
      LocaleKeys.standardCost.tr,
      LocaleKeys.picturePath.tr,
      LocaleKeys.maxStock.tr,
      LocaleKeys.minStock.tr,
      "${LocaleKeys.price.tr}1",
      "${LocaleKeys.price.tr}2",
      "${LocaleKeys.price.tr}3",
      "${LocaleKeys.price.tr}4",
      "${LocaleKeys.price.tr}5",
      LocaleKeys.qty.tr,
      LocaleKeys.soldOut.tr,
      LocaleKeys.notDiscount.tr,
      LocaleKeys.noServiceCharge.tr,
      LocaleKeys.sort.tr,
      LocaleKeys.nonStock.tr,
      LocaleKeys.nonEnable.tr,
      LocaleKeys.prePaid.tr,
      LocaleKeys.multipleCategory.tr,
    ];
    for (int col = 0; col < headers.length; col++) {
      var headerCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0));
      headerCell.value = TextCellValue(headers[col]);
      headerCell.cellStyle = _headStyle;
    }

    for (int row = 0; row < result.length; row++) {
      final ProductExportResult itemData = result[row];
      final List<dynamic> rowData = [
        itemData.mBarcode,
        itemData.mCode,
        itemData.mUnit,
        itemData.mDesc1,
        itemData.mDesc2,
        itemData.mRemarks,
        itemData.mCategory1,
        itemData.mCategory2,
        itemData.mMeasurement,
        itemData.mSupplierCode,
        itemData.mRefCode,
        itemData.mStandardCost,
        itemData.mPicturePath,
        itemData.mMaxLevel,
        itemData.mMinLevel,
        itemData.mPrice1 ?? "0.00",
        itemData.mPrice2 ?? "0.00",
        itemData.mPrice3 ?? "0.00",
        itemData.mPrice4 ?? "0.00",
        itemData.mPrice5 ?? "0.00",
        itemData.mQty ?? "0",
        itemData.mSoldOut ?? 0,
        itemData.mNonDiscount,
        itemData.mNonCharge,
        itemData.sort,
        itemData.mNonStock,
        itemData.mNonActived,
        itemData.mPrePaid,
        itemData.mCategory3,
      ];
      for (int col = 0; col < headers.length; col++) {
        final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row + 1));
        final cellValue = rowData[col];
        if (col == 13) {
          cell.value = FormulaCellValue("<table><img src=\"$cellValue\" height=50 width=50></table>");
        } else {
          cell.value = _toCellValue(cellValue);
        }
      }
    }

    final fileBytes = excel.save();

    await FileStorage.saveFileToDownloads(
      Uint8List.fromList(fileBytes!),
      "Product${DateTime.now().millisecondsSinceEpoch}.xlsx",
    );
  }
}
