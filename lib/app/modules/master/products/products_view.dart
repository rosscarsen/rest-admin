import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../config.dart';
import '../../../routes/app_pages.dart';
import '../../../translations/locale_keys.dart';
import '../../../utils/constants.dart';
import '../../../utils/progresshub.dart';
import '../../../widgets/custom_cell.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/data_pager.dart';
import 'products_controller.dart';

class ProductsView extends GetView<ProductsController> {
  const ProductsView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      route: Routes.PRODUCTS,
      body: Obx(() {
        return Column(
          spacing: Config.defaultGap,
          children: <Widget>[
            _buildToolBar(context),
            Expanded(child: ProgressHUD(child: controller.isLoading.value ? null : _buildDataGrid(context))),
            DataPager(
              totalPages: controller.totalPages,
              currentPage: controller.currentPage,
              onPageChanged: (int pageNumber) {
                controller.currentPage.value = pageNumber;
                controller.updateDataGridSource();
              },
            ),
          ],
        ).paddingAll(Config.defaultPadding);
      }),
      title: LocaleKeys.product.tr,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: controller.hasPermission.value ? () => controller.reloadData() : null,
        ),
      ],
    );
    /* Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.product.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.hasPermission.value ? () => controller.reloadData() : null,
          ),
        ],
      ),
      body: Obx(() {
        return Column(
          spacing: Config.defaultGap,
          children: <Widget>[
            _buildToolBar(context),
            Expanded(child: ProgressHUD(child: controller.isLoading.value ? null : _buildDataGrid(context))),
            DataPager(
              totalPages: controller.totalPages,
              currentPage: controller.currentPage,
              onPageChanged: (int pageNumber) {
                controller.currentPage.value = pageNumber;
                controller.updateDataGridSource();
              },
            ),
          ],
        ).paddingAll(Config.defaultPadding);
      }),
    ); */
  }

  //toolbar
  Widget _buildToolBar(BuildContext context) {
    return ResponsiveGridRow(
      children: [
        //搜索
        ResponsiveGridCol(
          xs: 12,
          sm: 6,
          md: 4,
          lg: 3,
          xl: 2,
          child: TextField(
            controller: controller.searchController,
            textInputAction: TextInputAction.search,
            onSubmitted: controller.hasPermission.value ? (value) => controller.reloadData() : null,
            decoration: InputDecoration(
              enabled: controller.hasPermission.value,
              hintText: LocaleKeys.keyWord.tr,
              suffixIcon: TextButton(
                onPressed: controller.hasPermission.value ? () => controller.reloadData() : null,
                child: Text(LocaleKeys.search.tr),
              ),
            ),
          ).paddingSymmetric(vertical: 2.0),
        ),
        //按钮
        ResponsiveGridCol(
          xs: 12,
          sm: 6,
          md: 8,
          lg: 9,
          xl: 10,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 44),
            child: Align(
              alignment: context.isPhoneOrLess ? Alignment.centerLeft : Alignment.centerRight,

              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: context.isPhoneOrLess ? WrapAlignment.start : WrapAlignment.end,
                spacing: 5,
                runSpacing: 5,
                children: [
                  //进阶搜索
                  ElevatedButton(
                    onPressed: controller.hasPermission.value
                        ? () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            Map<String, dynamic>? advancedSearch = await Get.toNamed(
                              Routes.ADVANCED_SEARCH,
                              arguments: controller.advancedSearch,
                            );
                            if (advancedSearch != null && advancedSearch.isNotEmpty) {
                              controller.advancedSearch.clear();
                              controller.advancedSearch.addAll(advancedSearch);
                              controller.reloadData();
                            }
                          }
                        : null,
                    child: Text(LocaleKeys.advancedSearch.tr),
                  ),
                  //依编号
                  ElevatedButton(
                    onPressed: controller.hasPermission.value ? () => controller.sortButton(isByCode: true) : null,
                    child: Text(LocaleKeys.byCode.tr),
                  ),
                  //依排序
                  ElevatedButton(
                    onPressed: controller.hasPermission.value ? () => controller.sortButton(isByCode: false) : null,
                    child: Text(LocaleKeys.bySort.tr),
                  ),
                  //批量删除食品
                  ElevatedButton(
                    onPressed: controller.hasPermission.value ? () => controller.deleteSelectedRows() : null,
                    child: Text(LocaleKeys.batchDeleteProduct.tr),
                  ),
                  //批量删除套餐
                  ElevatedButton(
                    onPressed: controller.hasPermission.value ? () => controller.deleteSelectedSetMeal() : null,
                    child: Text(LocaleKeys.batchDeleteSetMeal.tr),
                  ),
                  //打印条码
                  ElevatedButton(
                    onPressed: controller.hasPermission.value ? () => _printBarcode() : null,
                    child: Text(LocaleKeys.printBarcode.tr),
                  ),
                  //导入
                  ElevatedButton(
                    onPressed: controller.hasPermission.value ? () {} : null,
                    child: Text(LocaleKeys.import.tr),
                  ),
                  //导出
                  ElevatedButton(
                    onPressed: controller.hasPermission.value ? () => controller.exportProduct() : null,
                    child: Text(LocaleKeys.export.tr),
                  ),
                  //新增
                  ElevatedButton(
                    onPressed: controller.hasPermission.value ? () {} : null,
                    child: Text(LocaleKeys.add.tr),
                  ),
                ],
              ).paddingSymmetric(vertical: 2.0).paddingOnly(left: context.isPhoneOrLess ? 0 : 5),
            ),
          ),
        ),
      ],
    );
  }

  ///打印条码
  void _printBarcode() {
    final TextEditingController startCodeController = TextEditingController();
    final TextEditingController endCodeController = TextEditingController();
    int printPrice = 0;
    Get.defaultDialog(
      barrierDismissible: false,
      title: LocaleKeys.printBarcode.tr,
      content: SingleChildScrollView(
        child: Column(
          spacing: 10.0,
          children: <Widget>[
            TextField(
              controller: startCodeController,
              decoration: InputDecoration(
                labelText: LocaleKeys.startCode.tr,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                suffixIcon: IconButton(
                  onPressed: () async {
                    var result = await Get.toNamed(Routes.OPEN_PRODUCT_BARCODE);
                    if (result != null) {
                      startCodeController.text = result;
                    }
                  },
                  icon: Icon(Icons.file_open, color: AppColors.openColor),
                ),
              ),
            ),
            TextField(
              controller: endCodeController,
              decoration: InputDecoration(
                labelText: LocaleKeys.endCode.tr,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                suffixIcon: IconButton(
                  onPressed: () async {
                    var result = await Get.toNamed(Routes.OPEN_PRODUCT_BARCODE);
                    if (result != null) {
                      endCodeController.text = result;
                    }
                  },
                  icon: Icon(Icons.file_open, color: AppColors.openColor),
                ),
              ),
            ),
            StatefulBuilder(
              builder: (BuildContext context, setState) {
                return DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: LocaleKeys.price.tr,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  value: printPrice,
                  items: [
                    DropdownMenuItem(value: 0, child: Text(LocaleKeys.no.tr)),
                    DropdownMenuItem(value: 1, child: Text(LocaleKeys.yes.tr)),
                  ],
                  onChanged: (value) {
                    setState(() => printPrice = value!);
                  },
                );
              },
            ),
          ],
        ),
      ),
      cancel: ElevatedButton(
        onPressed: () {
          startCodeController.dispose();
          endCodeController.dispose();
          Get.closeDialog();
        },
        child: Text(LocaleKeys.cancel.tr),
      ),
      confirm: ElevatedButton(
        onPressed: () {
          startCodeController.dispose();
          endCodeController.dispose();
          Get.closeDialog();
          Get.toNamed(
            Routes.PDF,
            parameters: {
              'startCode': startCodeController.text,
              'endCode': endCodeController.text,
              'printPrice': printPrice.toString(),
              'type': 'masterPrintBarcode',
            },
          );
        },
        child: Text(LocaleKeys.confirm.tr),
      ),
    );
  }

  //数据表格
  Widget _buildDataGrid(BuildContext context) {
    return SelectionArea(
      child: SfDataGridTheme(
        data: SfDataGridThemeData(
          gridLineColor: Colors.grey.shade300,
          currentCellStyle: DataGridCurrentCellStyle(
            borderColor: Colors.transparent, // 避免选中单元格边框影响
            borderWidth: 0,
          ),
        ),
        child: SfDataGrid(
          isScrollbarAlwaysShown: true,
          controller: controller.dataGridController,
          footerFrozenColumnsCount: 2,
          frozenColumnsCount: 1,
          gridLinesVisibility: GridLinesVisibility.both,
          headerGridLinesVisibility: GridLinesVisibility.both,
          columnWidthMode: controller.dataSource.rows.isEmpty
              ? context.isPhoneOrLess
                    ? ColumnWidthMode.fitByColumnName
                    : ColumnWidthMode.fill
              : ColumnWidthMode.auto,
          columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
          showCheckboxColumn: true,
          selectionMode: SelectionMode.multiple,
          onCellTap: (details) {
            //print(details.rowColumnIndex);
          },
          source: controller.dataSource,
          /* onQueryRowHeight: (details) {
                return details.getIntrinsicRowHeight(details.rowIndex);
              }, */
          columns: <GridColumn>[
            GridColumn(
              columnName: "ID",
              visible: false,
              label: CustomCell(data: "ID"),
            ),
            GridColumn(
              columnName: "code",
              label: CustomCell(data: LocaleKeys.code.tr),
            ),
            GridColumn(
              columnName: 'name',
              label: CustomCell(data: LocaleKeys.name.tr),
            ),
            GridColumn(
              columnName: 'kitchenList',
              label: CustomCell(data: LocaleKeys.kitchenList.tr),
            ),
            GridColumn(
              columnName: 'keyName',
              label: CustomCell(data: LocaleKeys.keyName.tr),
            ),
            GridColumn(
              columnName: 'soldOut',
              label: CustomCell(data: LocaleKeys.soldOut.tr),
            ),
            GridColumn(
              columnName: 'category1',
              label: CustomCell(data: "${LocaleKeys.category.tr}1"),
            ),
            GridColumn(
              columnName: 'category2',
              label: CustomCell(data: "${LocaleKeys.category.tr}2"),
            ),
            GridColumn(
              columnName: 'price',
              label: CustomCell(data: LocaleKeys.price.tr),
            ),
            GridColumn(
              columnName: 'productRemarks',
              label: CustomCell(data: LocaleKeys.productRemarks.tr),
            ),
            GridColumn(
              columnName: 'discount',
              label: CustomCell(data: LocaleKeys.discount.tr),
            ),
            GridColumn(
              columnName: 'setMeal',
              label: CustomCell(data: LocaleKeys.setMeal.tr),
            ),
            GridColumn(
              columnName: 'sort',
              label: CustomCell(data: LocaleKeys.sort.tr),
            ),
            GridColumn(
              columnName: 'picture',
              width: 70,
              label: CustomCell(data: LocaleKeys.picture.tr),
            ),
            GridColumn(
              allowSorting: false,
              columnName: 'actions',
              width: context.isPhoneOrWider ? 200 : 60,
              label: CustomCell(data: LocaleKeys.operation.tr),
            ),
          ],
          placeholder: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.thumb_down_alt_outlined, size: 30),
                SizedBox(height: 8),
                Text(
                  controller.hasPermission.value ? LocaleKeys.noRecordFound.tr : LocaleKeys.noPermission.tr,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
