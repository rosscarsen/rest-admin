import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../model/supplier/supplier_data.dart';
import '../../../../routes/app_pages.dart';
import '../../../../translations/locale_keys.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/custom_dialog.dart';
import '../../../../utils/form_help.dart';
import '../../../../utils/progress_hub.dart';
import '../../../../widgets/custom_cell.dart';
import '../../../../widgets/data_grid_theme.dart';
import '../../../../widgets/no_record.dart';
import '../../../../widgets/table_input_theme.dart';
import '../../../open/open_set_meal/open_set_meal_view.dart';
import 'copy_product_set_meal/copy_product_set_meal_view.dart';
import 'product_edit_controller.dart';
import 'product_edit_fields.dart';

class ProductEditView extends GetView<ProductEditController> {
  const ProductEditView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(controller.title.value),
          centerTitle: true,
          actions: [
            Tooltip(
              message: LocaleKeys.refresh.tr,
              child: IconButton(
                onPressed: () {
                  controller.updateDataGridSource();
                },
                icon: FaIcon(Icons.refresh),
              ),
            ),
          ],
          bottom: controller.hasPermission.value
              ? PreferredSize(
                  preferredSize: Size.fromHeight(48.0),
                  child: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: TabBar(
                      isScrollable: true,
                      controller: controller.tabController,
                      tabs: controller.tabs,
                      labelColor: Colors.blueAccent,
                      indicatorColor: Colors.blueAccent,
                      indicatorWeight: 2,
                      indicatorSize: TabBarIndicatorSize.label,
                      unselectedLabelColor: Colors.grey.shade600,
                      overlayColor: WidgetStateProperty.all(Colors.blue.withValues(alpha: 0.1)),
                      tabAlignment: TabAlignment.start,
                    ),
                  ),
                )
              : null,
        ),
        body: controller.hasPermission.value
            ? _buildTabBarView(context)
            : Center(
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
        persistentFooterButtons: [
          FormHelper.saveButton(onPressed: controller.hasPermission.value ? controller.productAddOrEditSave : null),
        ],
      ),
    );
  }

  // 主视图
  Widget _buildTabBarView(BuildContext context) {
    return FormBuilder(
      key: controller.productEditFormKey,
      child: IndexedStack(
        index: controller.tabIndex.value.clamp(0, controller.tabs.length - 1),
        children: [
          _buildProduct(context: context),
          _buildDetail(context: context),
          _buildBarcode(context: context),
          _buildShop(context: context),
          _buildSetMealLimit(context: context),
          _buildSetMeal(context: context),
        ],
      ),
    );
  }

  // 产品视图
  Widget _buildProduct({required BuildContext context}) {
    return Skeletonizer(
      enabled: controller.isLoading.value,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FocusTraversalGroup(
            child: FormHelper.buildGridRow(
              children: [
                //类目1
                FormHelper.buildGridCol(
                  child: FormHelper.selectInput(
                    name: ProductEditFields.mCategory1,
                    labelText: "${LocaleKeys.category.tr}1",
                    items: [
                      DropdownMenuItem(value: "", child: Text("")),
                      if (controller.category1.isNotEmpty)
                        ...controller.category1.map(
                          (e) => DropdownMenuItem(
                            value: e.mCategory.toString(),
                            child: Row(
                              spacing: 8.0,
                              children: [
                                Text(e.mCategory.toString()),
                                Flexible(child: Text(e.mDescription.toString())),
                              ],
                            ),
                          ),
                        ),
                    ],
                    onChanged: (String? category1) {
                      controller.generateCategory2(category1);
                    },
                  ),
                ),
                //类目2
                FormHelper.buildGridCol(
                  child: FormHelper.selectInput(
                    name: ProductEditFields.mCategory2,
                    labelText: "${LocaleKeys.category.tr}2",
                    items: [
                      DropdownMenuItem(value: "", child: Text("")),
                      if (controller.category2.isNotEmpty)
                        ...controller.category2.map(
                          (e) => DropdownMenuItem(
                            value: e.mCategory,
                            child: Row(
                              spacing: 8.0,
                              children: [
                                Text(e.mCategory.toString()),
                                Flexible(child: Text(e.mDescription.toString())),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                //创建日期
                FormHelper.buildGridCol(
                  child: FormHelper.dateInput(
                    name: ProductEditFields.mDate_Create,
                    labelText: LocaleKeys.createDate.tr,
                    enabled: false,
                    inputType: DateInputType.dateAndTime,
                    canClear: false,
                  ),
                ),
                //编号
                FormHelper.buildGridCol(
                  child: FormHelper.textInput(
                    name: ProductEditFields.mCode,
                    labelText: LocaleKeys.code.tr,
                    enabled: Get.parameters.isEmpty,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return LocaleKeys.thisFieldIsRequired.tr;
                      }
                      return null;
                    },
                  ),
                ),
                //价钱1
                FormHelper.buildGridCol(
                  child: FormHelper.textInput(
                    name: ProductEditFields.mPrice,
                    labelText: "${LocaleKeys.price.tr}1",
                    keyboardType: TextInputType.number,
                  ),
                ),
                //修改日期
                FormHelper.buildGridCol(
                  child: FormHelper.dateInput(
                    name: ProductEditFields.mDate_Modify,
                    labelText: LocaleKeys.modifyDate.tr,
                    enabled: false,
                    inputType: DateInputType.dateAndTime,
                    canClear: false,
                  ),
                ),
                //名称
                FormHelper.buildGridCol(
                  child: FormHelper.textInput(
                    name: ProductEditFields.mDesc1,
                    labelText: LocaleKeys.name.tr,
                    maxLines: 2,
                    onChanged: (value) {
                      controller.productEditFormKey.currentState?.patchValue({
                        ProductEditFields.mDesc2: value?.trim(),
                        ProductEditFields.mRemarks: value?.trim(),
                      });
                    },
                  ),
                ),
                //厨房单
                FormHelper.buildGridCol(
                  child: FormHelper.textInput(
                    name: ProductEditFields.mDesc2,
                    labelText: LocaleKeys.kitchenList.tr,
                    maxLines: 2,
                  ),
                ),
                //按键名称
                FormHelper.buildGridCol(
                  child: FormHelper.textInput(
                    name: ProductEditFields.mRemarks,
                    labelText: LocaleKeys.keyName.tr,
                    maxLines: 2,
                  ),
                ),
                //食品备注
                FormHelper.buildGridCol(
                  child: FormHelper.openInput(
                    name: ProductEditFields.mMeasurement,
                    labelText: LocaleKeys.productRemarks.tr,
                    onPressed: () async {
                      String? result = await Get.toNamed(Routes.OPEN_PRODUCT_REMARKS);
                      if (result?.isNotEmpty ?? false) {
                        controller.productEditFormKey.currentState?.fields[ProductEditFields.mMeasurement]?.didChange(
                          result,
                        );
                      }
                    },
                  ),
                ),
                //单位
                FormHelper.buildGridCol(
                  child: FormHelper.selectInput(
                    name: ProductEditFields.mUnit,
                    labelText: LocaleKeys.unit.tr,
                    items: [
                      DropdownMenuItem(value: "", child: Text("")),
                      if (controller.units.isNotEmpty)
                        ...controller.units.map(
                          (e) => DropdownMenuItem(
                            value: e.mUnit,
                            child: FittedBox(child: Text(e.mUnit.toString())),
                          ),
                        ),
                    ],
                  ),
                ),
                //售罄
                FormHelper.buildGridCol(
                  child: FormHelper.selectInput(
                    name: ProductEditFields.mSoldOut,
                    labelText: LocaleKeys.soldOut.tr,
                    items: [
                      DropdownMenuItem(value: "0", child: Text(LocaleKeys.no.tr)),
                      DropdownMenuItem(value: "1", child: Text(LocaleKeys.yes.tr)),
                    ],
                  ),
                ),
                //不具折上折
                FormHelper.buildGridCol(
                  child: FormHelper.selectInput(
                    name: ProductEditFields.mNon_Discount,
                    labelText: LocaleKeys.notDiscount.tr,
                    items: [
                      DropdownMenuItem(value: "0", child: Text(LocaleKeys.no.tr)),
                      DropdownMenuItem(value: "1", child: Text(LocaleKeys.yes.tr)),
                    ],
                  ),
                ),
                //不具服务费
                FormHelper.buildGridCol(
                  child: FormHelper.selectInput(
                    name: ProductEditFields.mNonCharge,
                    labelText: LocaleKeys.noServiceCharge.tr,
                    items: [
                      DropdownMenuItem(value: "0", child: Text(LocaleKeys.no.tr)),
                      DropdownMenuItem(value: "1", child: Text(LocaleKeys.yes.tr)),
                    ],
                  ),
                ),
                //排序
                FormHelper.buildGridCol(
                  child: FormHelper.textInput(
                    name: ProductEditFields.mModel,
                    labelText: LocaleKeys.sort.tr,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 详细
  Widget _buildDetail({required BuildContext context}) {
    return Skeletonizer(
      enabled: controller.isLoading.value,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FocusTraversalGroup(
            child: FormHelper.buildGridRow(
              children: [
                //非库存食品
                FormHelper.buildGridCol(
                  child: FormHelper.selectInput(
                    name: ProductEditFields.mNon_Stock,
                    labelText: LocaleKeys.nonStock.tr,
                    items: [
                      DropdownMenuItem(value: "0", child: Text(LocaleKeys.no.tr)),
                      DropdownMenuItem(value: "1", child: Text(LocaleKeys.yes.tr)),
                    ],
                  ),
                ),
                //非启用
                FormHelper.buildGridCol(
                  child: FormHelper.selectInput(
                    name: ProductEditFields.mNonActived,
                    labelText: LocaleKeys.nonEnable.tr,
                    items: [
                      DropdownMenuItem(value: "0", child: Text(LocaleKeys.no.tr)),
                      DropdownMenuItem(value: "1", child: Text(LocaleKeys.yes.tr)),
                    ],
                  ),
                ),
                //价钱2
                FormHelper.buildGridCol(
                  child: FormHelper.textInput(
                    name: ProductEditFields.mBottom_Price,
                    labelText: "${LocaleKeys.price.tr}2",
                    keyboardType: TextInputType.number,
                  ),
                ),
                //价钱3
                FormHelper.buildGridCol(
                  child: FormHelper.textInput(
                    name: ProductEditFields.mPrice1,
                    labelText: "${LocaleKeys.price.tr}3",
                    keyboardType: TextInputType.number,
                  ),
                ),
                //价钱4
                FormHelper.buildGridCol(
                  child: FormHelper.textInput(
                    name: ProductEditFields.mPrice2,
                    labelText: "${LocaleKeys.price.tr}4",
                    keyboardType: TextInputType.number,
                  ),
                ),
                //价钱5
                FormHelper.buildGridCol(
                  child: FormHelper.textInput(
                    name: ProductEditFields.mPrice3,
                    labelText: "${LocaleKeys.price.tr}5",
                    keyboardType: TextInputType.number,
                  ),
                ),
                // 参考编号
                FormHelper.buildGridCol(
                  child: FormHelper.textInput(name: ProductEditFields.mRef_Code, labelText: LocaleKeys.refCode.tr),
                ),
                //供应商
                FormHelper.buildGridCol(
                  child: FormHelper.openInput(
                    name: ProductEditFields.mSupplier_Code,
                    labelText: LocaleKeys.supplier.tr,
                    onPressed: () async {
                      var result = await Get.toNamed(Routes.OPEN_SUPPLIER);
                      if (result != null && result is SupplierData) {
                        controller.productEditFormKey.currentState?.fields[ProductEditFields.mSupplier_Code]?.didChange(
                          result.mCode ?? "",
                        );
                      }
                    },
                  ),
                ),
                // 预支付
                FormHelper.buildGridCol(
                  child: FormHelper.selectInput(
                    name: ProductEditFields.mPrePaid,
                    labelText: LocaleKeys.prePaid.tr,
                    items: [
                      DropdownMenuItem(value: "0", child: Text(LocaleKeys.no.tr)),
                      DropdownMenuItem(value: "1", child: Text(LocaleKeys.yes.tr)),
                    ],
                  ),
                ),
                //高存量
                FormHelper.buildGridCol(
                  child: FormHelper.textInput(
                    name: ProductEditFields.mMax_Level,
                    labelText: LocaleKeys.maxStock.tr,
                    keyboardType: TextInputType.number,
                  ),
                ),
                //低存量
                FormHelper.buildGridCol(
                  child: FormHelper.textInput(
                    name: ProductEditFields.mMin_Level,
                    labelText: LocaleKeys.minStock.tr,
                    keyboardType: TextInputType.number,
                  ),
                ),
                // 最后卖价
                FormHelper.buildGridCol(
                  child: FormHelper.textInput(
                    name: ProductEditFields.mLat_Price,
                    labelText: LocaleKeys.lastPrice.tr,
                    keyboardType: TextInputType.number,
                    enabled: false,
                  ),
                ),
                // 平均成本
                FormHelper.buildGridCol(
                  child: FormHelper.textInput(
                    name: ProductEditFields.mAv_Cost,
                    labelText: LocaleKeys.averageCost.tr,
                    keyboardType: TextInputType.number,
                    enabled: false,
                  ),
                ),
                // 最后成本
                FormHelper.buildGridCol(
                  child: FormHelper.textInput(
                    name: ProductEditFields.mLat_Cost,
                    labelText: LocaleKeys.lastCost.tr,
                    keyboardType: TextInputType.number,
                    enabled: false,
                  ),
                ),
                // 标准成本
                FormHelper.buildGridCol(
                  child: FormHelper.textInput(
                    name: ProductEditFields.mStandard_Cost,
                    labelText: LocaleKeys.stdCost.tr,
                    keyboardType: TextInputType.number,
                  ),
                ),
                // 图片路径
                FormHelper.buildGridCol(
                  sm: 12,
                  md: 12,
                  lg: 12,
                  xl: 12,
                  child: FormHelper.textInput(
                    name: ProductEditFields.mPicture_Path,
                    labelText: LocaleKeys.picturePath.tr,
                  ),
                ),
                // 多类别
                FormHelper.buildGridCol(
                  sm: 12,
                  md: 12,
                  lg: 12,
                  xl: 12,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      LocaleKeys.multipleCategory.tr,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                ...controller.categories.map((item) {
                  final ScrollController scrollController = ScrollController();
                  return FormHelper.buildGridCol(
                    sm: 12,
                    md: 6,
                    lg: 4,
                    xl: 4,
                    child: Container(
                      padding: EdgeInsets.all(4.0),
                      margin: EdgeInsets.all(4.0),
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.fromBorderSide(Divider.createBorderSide(context, width: 1.0)),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Column(
                        spacing: 4,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${item.mDescription ?? ""}(${item.children?.length ?? 0})",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Scrollbar(
                              thickness: 8,
                              radius: Radius.circular(5),
                              thumbVisibility: true,
                              interactive: true,
                              controller: scrollController,
                              child: SingleChildScrollView(
                                controller: scrollController,
                                child: item.children?.isEmpty ?? false
                                    ? null
                                    : FormBuilderCheckboxGroup(
                                        initialValue: controller.productCategory3.value
                                            .where(
                                              (value) =>
                                                  item.children?.any((child) => child.mCategory?.toString() == value) ??
                                                  false,
                                            )
                                            .toList(), //controller.productCategory3.value,
                                        orientation: OptionsOrientation.vertical,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                        ),
                                        name: "multipleCategory_${item.tCategoryId}",
                                        options: item.children?.isEmpty ?? false
                                            ? []
                                            : item.children!
                                                  .asMap()
                                                  .entries
                                                  .map(
                                                    (entry) => FormBuilderFieldOption(
                                                      value: entry.value.mCategory?.toString() ?? "",
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            '(${entry.key + 1}) ${entry.value.mCategory?.toString()} ',
                                                          ),
                                                          Flexible(child: Text(entry.value.mDescription ?? "")),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 条码视图
  Widget _buildBarcode({required BuildContext context}) {
    return ProgressHUD(
      child: controller.isLoading.value
          ? null
          : SelectionArea(
              child: SfDataGridTheme(
                data: SfDataGridThemeData(
                  gridLineColor: Colors.grey.shade300,
                  currentCellStyle: DataGridCurrentCellStyle(
                    borderColor: Colors.transparent, // 避免选中单元格边框影响
                    borderWidth: 0,
                  ),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    spacing: 8.0,

                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton(
                          child: Text(LocaleKeys.barcodeAdd.tr),
                          onPressed: () async {
                            await controller.editOrAddProductBarcode();
                          },
                        ),
                      ),
                      Expanded(
                        child: SfDataGrid(
                          /* onQueryRowHeight: (details) {
                            return details.getIntrinsicRowHeight(details.rowIndex);
                          }, */
                          isScrollbarAlwaysShown: true,
                          controller: controller.barcodeDataGridController,
                          footerFrozenColumnsCount: 1,
                          frozenColumnsCount: 0,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          columnWidthMode: controller.productBarcodeSource.rows.isEmpty
                              ? context.isPhoneOrLess
                                    ? ColumnWidthMode.fitByColumnName
                                    : ColumnWidthMode.fill
                              : ColumnWidthMode.auto,
                          columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
                          columnSizer: ColumnSizer(),
                          allowSorting: false,
                          showCheckboxColumn: false,
                          source: controller.productBarcodeSource,
                          columns: <GridColumn>[
                            GridColumn(
                              columnName: "barcode",
                              label: CustomCell(data: LocaleKeys.barcode.tr),
                            ),
                            GridColumn(
                              columnName: 'name',
                              label: CustomCell(data: LocaleKeys.name.tr),
                              columnWidthMode: context.isPhoneOrLess ? ColumnWidthMode.auto : ColumnWidthMode.fill,
                            ),
                            GridColumn(
                              columnName: 'nonEnable',
                              label: CustomCell(data: LocaleKeys.nonEnable.tr),
                            ),
                            GridColumn(
                              columnName: 'remarks',
                              label: CustomCell(data: LocaleKeys.remarks.tr),
                              maximumWidth: context.isPhoneOrLess ? 500 : double.nan,
                              minimumWidth: 200,
                            ),
                            GridColumn(
                              allowSorting: false,
                              columnName: 'actions',
                              width: 100,
                              label: CustomCell(data: LocaleKeys.operation.tr),
                            ),
                          ],
                          placeholder: NoRecordPermission(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // 库存视图
  Widget _buildShop({required BuildContext context}) {
    return ProgressHUD(
      child: controller.isLoading.value
          ? null
          : SelectionArea(
              child: SfDataGridTheme(
                data: SfDataGridThemeData(
                  gridLineColor: Colors.grey.shade300,
                  currentCellStyle: DataGridCurrentCellStyle(
                    borderColor: Colors.transparent, // 避免选中单元格边框影响
                    borderWidth: 0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SfDataGrid(
                    isScrollbarAlwaysShown: true,
                    controller: controller.stockDataGridController,
                    footerFrozenColumnsCount: 0,
                    frozenColumnsCount: 0,
                    gridLinesVisibility: GridLinesVisibility.both,
                    headerGridLinesVisibility: GridLinesVisibility.both,
                    columnWidthMode: controller.setMealLimitSource.rows.isEmpty
                        ? context.isPhoneOrLess
                              ? ColumnWidthMode.fitByColumnName
                              : ColumnWidthMode.fill
                        : ColumnWidthMode.fill,
                    columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
                    columnSizer: ColumnSizer(),
                    allowSorting: false,
                    showCheckboxColumn: false,
                    source: controller.productStockSource,
                    columns: <GridColumn>[
                      GridColumn(
                        columnName: "mCode",
                        label: CustomCell(data: LocaleKeys.code.tr),
                      ),
                      GridColumn(
                        columnName: 'mName',
                        label: CustomCell(data: LocaleKeys.name.tr),
                      ),

                      GridColumn(
                        columnName: 'qty',
                        label: CustomCell(data: LocaleKeys.qty.tr),
                      ),
                    ],
                    placeholder: NoRecordPermission(),
                  ),
                ),
              ),
            ),
    );
  }

  // 套餐限制
  Widget _buildSetMealLimit({required BuildContext context}) {
    return ProgressHUD(
      child: controller.isLoading.value
          ? null
          : DataGridTheme(
              child: Theme(
                data: ThemeData(inputDecorationTheme: tableInputTheme),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SfDataGrid(
                    isScrollbarAlwaysShown: true,
                    controller: controller.setMealLimitDataGridController,
                    footerFrozenColumnsCount: 0,
                    frozenColumnsCount: 0,
                    gridLinesVisibility: GridLinesVisibility.both,
                    headerGridLinesVisibility: GridLinesVisibility.both,
                    columnWidthMode: controller.setMealLimitSource.rows.isEmpty
                        ? context.isPhoneOrLess
                              ? ColumnWidthMode.fitByColumnName
                              : ColumnWidthMode.fill
                        : context.isPhoneOrLess
                        ? ColumnWidthMode.auto
                        : ColumnWidthMode.fill,
                    columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,

                    columnSizer: ColumnSizer(),
                    allowSorting: false,
                    showCheckboxColumn: false,
                    source: controller.setMealLimitSource,
                    columns: <GridColumn>[
                      GridColumn(
                        columnName: "setMealLimit",
                        label: CustomCell(data: LocaleKeys.setMealLimit.tr),
                      ),
                      GridColumn(
                        columnName: 'maxQty',
                        label: CustomCell(data: LocaleKeys.maxQty.tr),
                      ),

                      GridColumn(
                        columnName: 'forceSelect',
                        label: CustomCell(data: LocaleKeys.forceSelect.tr),
                      ),
                      GridColumn(
                        columnName: 'chinese',
                        label: CustomCell(data: LocaleKeys.chinese.tr),
                        allowEditing: true,
                      ),
                      GridColumn(
                        columnName: 'english',
                        label: CustomCell(data: LocaleKeys.english.tr),
                      ),
                    ],
                    placeholder: NoRecordPermission(),
                  ),
                ),
              ),
            ),
    );
  }

  // 套餐
  Widget _buildSetMeal({required BuildContext context}) {
    return Column(
      children: [
        Skeletonizer(
          enabled: controller.isLoading.value,
          child: FocusTraversalGroup(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: FormHelper.buildGridRow(
                children: [
                  // 选择
                  FormHelper.buildGridCol(
                    child: FormHelper.selectInput(
                      name: ProductEditFields.mSetOption,
                      labelText: LocaleKeys.choice.tr,
                      items: [
                        DropdownMenuItem(value: "0", child: Text(LocaleKeys.selectItemByItem.tr)),
                        DropdownMenuItem(value: "1", child: Text(LocaleKeys.listAll.tr)),
                      ],
                    ),
                  ),
                  // 选项
                  FormHelper.buildGridCol(
                    child: FormHelper.selectInput(
                      name: "setMealStep",
                      labelText: LocaleKeys.choice.tr,
                      initialValue: "0",
                      items: List.generate(
                        10,
                        (index) => DropdownMenuItem(
                          value: index.toString(),
                          child: Text(index == 0 ? LocaleKeys.all.tr : index.toString()),
                        ),
                      ),
                      onChanged: (val) {},
                    ),
                  ),
                  // 复制（食品）
                  FormHelper.buildGridCol(
                    child: SizedBox(
                      height: 40,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton(onPressed: copySetMeal, child: Text(LocaleKeys.copyProduct.tr)),
                      ),
                    ),
                  ),
                  // 复制（套餐）
                  FormHelper.buildGridCol(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 5.0,
                      children: [
                        Expanded(
                          child: ValueListenableBuilder(
                            valueListenable: controller.setMealController,
                            builder: (BuildContext context, TextEditingValue value, Widget? child) {
                              final hasText = value.text.isNotEmpty;
                              return FormHelper.textInput(
                                name: ProductEditFields.setMenu,
                                labelText: LocaleKeys.copySetMeal.tr,
                                controller: controller.setMealController,
                                readOnly: true,
                                suffixIcon: OverflowBar(
                                  children: [
                                    // 从套餐复制
                                    IconButton(
                                      onPressed: openSetMeal,
                                      tooltip: LocaleKeys.copySetMeal.tr,
                                      icon: Icon(Icons.file_open, color: AppColors.openColor),
                                    ),
                                    // 清除产品表setMenu栏位
                                    if (hasText)
                                      IconButton(
                                        tooltip: LocaleKeys.clearText.tr,
                                        onPressed: () => controller.updateSetMenu(""),
                                        icon: Icon(Icons.cancel),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        //更新套餐
                        ElevatedButton(
                          onPressed: () => controller.updateProductSetMeal(),
                          child: Text(LocaleKeys.updateSetMeal.tr),
                        ),
                      ],
                    ),
                  ),
                  // 批量刪除套餐 && 添加套餐
                  FormHelper.buildGridCol(
                    sm: 12,
                    md: 12,
                    lg: 12,
                    xl: 12,
                    child: OverflowBar(
                      alignment: MainAxisAlignment.start,
                      spacing: 8,
                      children: [
                        // 批量刪除套餐
                        ElevatedButton(
                          onPressed: () {
                            controller.batchDeleteSetMealItems();
                          },
                          child: Text(LocaleKeys.batchDelete.tr),
                        ),
                        // 添加套餐
                        ElevatedButton(
                          onPressed: () async {
                            await Get.toNamed(
                              Routes.OPEN_MULTIPLE_PRODUCT,
                              parameters: {"productId": controller.productID.toString(), "isShowOption": "Y"},
                            );
                          },
                          child: Text(LocaleKeys.setMealAdd.tr),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: ProgressHUD(
            child: controller.isLoading.value
                ? null
                : SelectionArea(
                    child: SfDataGridTheme(
                      data: SfDataGridThemeData(
                        gridLineColor: Colors.grey.shade300,
                        currentCellStyle: DataGridCurrentCellStyle(borderColor: Colors.transparent, borderWidth: 0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                        child: SfDataGrid(
                          isScrollbarAlwaysShown: true,
                          controller: controller.setMealDataGridController,
                          footerFrozenColumnsCount: 1,
                          frozenColumnsCount: 1,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          columnWidthMode: controller.productSetMealSource.rows.isEmpty
                              ? context.isPhoneOrLess
                                    ? ColumnWidthMode.fitByColumnName
                                    : ColumnWidthMode.fill
                              : ColumnWidthMode.auto,
                          columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
                          columnSizer: ColumnSizer(),
                          allowSorting: false,
                          showCheckboxColumn: true,
                          selectionMode: SelectionMode.multiple,
                          source: controller.productSetMealSource,
                          columns: <GridColumn>[
                            GridColumn(
                              columnName: "ID",
                              visible: false,
                              label: CustomCell(data: "ID"),
                            ),
                            GridColumn(
                              columnName: "mBarcode",
                              label: CustomCell(data: LocaleKeys.code.tr),
                              columnWidthMode: ColumnWidthMode.auto,
                            ),
                            GridColumn(
                              columnName: 'mName',
                              label: CustomCell(data: LocaleKeys.name.tr),
                              columnWidthMode: context.isPhoneOrLess ? ColumnWidthMode.auto : ColumnWidthMode.fill,
                              maximumWidth: context.isPhoneOrLess ? 500 : double.nan,
                              minimumWidth: 200,
                            ),
                            GridColumn(
                              columnName: 'mQty',
                              label: CustomCell(data: LocaleKeys.qty.tr),
                            ),
                            GridColumn(
                              columnName: 'mPrice',
                              label: CustomCell(data: LocaleKeys.price.tr),
                            ),
                            GridColumn(
                              columnName: 'mPrice2',
                              label: CustomCell(data: LocaleKeys.scorePrice.tr),
                            ),
                            GridColumn(
                              columnName: 'mStep',
                              label: CustomCell(data: LocaleKeys.option.tr),
                            ),
                            GridColumn(
                              columnName: 'mDefault',
                              label: CustomCell(data: LocaleKeys.defaultSelect.tr),
                            ),
                            GridColumn(
                              columnName: 'mSort',
                              label: CustomCell(data: LocaleKeys.sort.tr),
                            ),
                            GridColumn(
                              columnName: 'mRemarks',
                              label: CustomCell(data: LocaleKeys.remarks.tr),
                              maximumWidth: 500,
                            ),
                            GridColumn(
                              allowSorting: false,
                              columnName: 'actions',
                              width: 100,
                              label: CustomCell(data: LocaleKeys.operation.tr),
                            ),
                          ],
                          placeholder: NoRecordPermission(),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  // 复制（食品）function
  void copySetMeal() async {
    final ret = await Get.dialog(Dialog(child: CopyProductSetMealView()));
    final selectProductID = ret != null ? int.parse(ret.toString()) : 0;
    final currentProductID = controller.productID;
    if (selectProductID == 0) {
      return;
    }
    if (selectProductID == currentProductID) {
      return CustomDialog.errorMessages(LocaleKeys.copySameProduct.tr);
    }
    if (ret != null) {
      final Map<String, dynamic> query = {"selectProductID": selectProductID, "currentProductID": currentProductID};
      await controller.copyProductSetMeal(query);
    }
  }

  // 打开套餐
  void openSetMeal() async {
    final ret = await Get.dialog(Dialog(child: OpenSetMealView()));
    final selectCode = (ret?.toString() ?? "").trim();
    if (selectCode.isEmpty) {
      return;
    }
    await controller.updateSetMenu(selectCode);
  }
}
