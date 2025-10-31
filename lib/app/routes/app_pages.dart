import 'package:get/get.dart';

import '../Middlewares/auth_middleware.dart';
import '../modules/dashboard/dashboard_binding.dart';
import '../modules/dashboard/dashboard_view.dart';
import '../modules/master/calendar/calendar_binding.dart';
import '../modules/master/calendar/calendar_view.dart';
import '../modules/master/category/category2/category2_binding.dart';
import '../modules/master/category/category2/category2_edit/category2_edit_binding.dart';
import '../modules/master/category/category2/category2_edit/category2_edit_view.dart';
import '../modules/master/category/category2/category2_view.dart';
import '../modules/master/category/category_binding.dart';
import '../modules/master/category/category_edit/category_edit_binding.dart';
import '../modules/master/category/category_edit/category_edit_view.dart';
import '../modules/master/category/category_view.dart';
import '../modules/master/currency/currency_binding.dart';
import '../modules/master/currency/currency_edit/currency_edit_binding.dart';
import '../modules/master/currency/currency_edit/currency_edit_view.dart';
import '../modules/master/currency/currency_view.dart';
import '../modules/master/customer/customer_binding.dart';
import '../modules/master/customer/customer_edit/customer_edit_binding.dart';
import '../modules/master/customer/customer_edit/customer_edit_view.dart';
import '../modules/master/customer/customer_view.dart';
import '../modules/master/decca/decca_binding.dart';
import '../modules/master/decca/decca_view.dart';
import '../modules/master/department/department_binding.dart';
import '../modules/master/department/department_edit/department_edit_binding.dart';
import '../modules/master/department/department_edit/department_edit_view.dart';
import '../modules/master/department/department_view.dart';
import '../modules/master/master_binding.dart';
import '../modules/master/master_view.dart';
import '../modules/master/mesa/mesa_binding.dart';
import '../modules/master/mesa/mesa_view.dart';
import '../modules/master/network_pay_method/net_work_pay_method_edit/net_work_pay_method_edit_binding.dart';
import '../modules/master/network_pay_method/net_work_pay_method_edit/net_work_pay_method_edit_view.dart';
import '../modules/master/network_pay_method/network_pay_method_binding.dart';
import '../modules/master/network_pay_method/network_pay_method_view.dart';
import '../modules/master/pay_method/pay_method_binding.dart';
import '../modules/master/pay_method/pay_method_view.dart';
import '../modules/master/printer/printer_binding.dart';
import '../modules/master/printer/printer_view.dart';
import '../modules/master/product_remarks/product_remarks_binding.dart';
import '../modules/master/product_remarks/product_remarks_edit/product_remarks_edit_binding.dart';
import '../modules/master/product_remarks/product_remarks_edit/product_remarks_edit_view.dart';
import '../modules/master/product_remarks/product_remarks_view.dart';
import '../modules/master/products/advancedSearch/advanced_search_binding.dart';
import '../modules/master/products/advancedSearch/advanced_search_view.dart';
import '../modules/master/products/product_edit/copy_product_set_meal/copy_product_set_meal_binding.dart';
import '../modules/master/products/product_edit/copy_product_set_meal/copy_product_set_meal_view.dart';
import '../modules/master/products/product_edit/product_edit_binding.dart';
import '../modules/master/products/product_edit/product_edit_view.dart';
import '../modules/master/products/products_binding.dart';
import '../modules/master/products/products_view.dart';
import '../modules/master/screen_mode_category/screen_mode_category_binding.dart';
import '../modules/master/screen_mode_category/screen_mode_category_view.dart';
import '../modules/master/set_menu/set_menu_binding.dart';
import '../modules/master/set_menu/set_menu_edit/set_menu_edit_binding.dart';
import '../modules/master/set_menu/set_menu_edit/set_menu_edit_view.dart';
import '../modules/master/set_menu/set_menu_view.dart';
import '../modules/master/stock/stock_binding.dart';
import '../modules/master/stock/stock_edit/stock_edit_binding.dart';
import '../modules/master/stock/stock_edit/stock_edit_view.dart';
import '../modules/master/stock/stock_view.dart';
import '../modules/master/supplier/supplier_binding.dart';
import '../modules/master/supplier/supplier_edit/supplier_edit_binding.dart';
import '../modules/master/supplier/supplier_edit/supplier_edit_view.dart';
import '../modules/master/supplier/supplier_view.dart';
import '../modules/master/time_sales/time_sales_binding.dart';
import '../modules/master/time_sales/time_sales_view.dart';
import '../modules/master/unit/unit_binding.dart';
import '../modules/master/unit/unit_edit/unit_edit_binding.dart';
import '../modules/master/unit/unit_edit/unit_edit_view.dart';
import '../modules/master/unit/unit_view.dart';
import '../modules/open/open_binding.dart';
import '../modules/open/open_customer/open_customer_binding.dart';
import '../modules/open/open_customer/open_customer_view.dart';
import '../modules/open/open_multiple_product/open_multiple_product_binding.dart';
import '../modules/open/open_multiple_product/open_multiple_product_view.dart';
import '../modules/open/open_product/open_product_binding.dart';
import '../modules/open/open_product/open_product_view.dart';
import '../modules/open/open_product_barcode/open_product_barcode_binding.dart';
import '../modules/open/open_product_barcode/open_product_barcode_view.dart';
import '../modules/open/open_product_remarks/open_product_remarks_binding.dart';
import '../modules/open/open_product_remarks/open_product_remarks_view.dart';
import '../modules/open/open_set_meal/open_set_meal_binding.dart';
import '../modules/open/open_set_meal/open_set_meal_view.dart';
import '../modules/open/open_supplier/open_supplier_binding.dart';
import '../modules/open/open_supplier/open_supplier_view.dart';
import '../modules/open/open_view.dart';
import '../modules/page_not_found/page_not_found_binding.dart';
import '../modules/page_not_found/page_not_found_view.dart';
import '../modules/pdf/pdf_binding.dart';
import '../modules/pdf/pdf_view.dart';
import '../modules/signin/signin_binding.dart';
import '../modules/signin/signin_view.dart';
import '../modules/supplier_invoice/supplier_invoice_binding.dart';
import '../modules/supplier_invoice/supplier_invoice_edit/supplier_invoice_edit_binding.dart';
import '../modules/supplier_invoice/supplier_invoice_edit/supplier_invoice_edit_view.dart';
import '../modules/supplier_invoice/supplier_invoice_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(name: _Paths.SIGNIN, page: () => const SigninView(), binding: SigninBinding()),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.OPEN,
      page: () => const OpenView(),
      binding: OpenBinding(),
      children: [
        GetPage(
          name: _Paths.OPEN_PRODUCT,
          page: () => const OpenProductView(),
          binding: OpenProductBinding(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: _Paths.OPEN_SUPPLIER,
          page: () => const OpenSupplierView(),
          binding: OpenSupplierBinding(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: _Paths.OPEN_PRODUCT_BARCODE,
          page: () => const OpenProductBarcodeView(),
          binding: OpenProductBarcodeBinding(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: _Paths.OPEN_PRODUCT_REMARKS,
          page: () => const OpenProductRemarksView(),
          binding: OpenProductRemarksBinding(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: _Paths.OPEN_MULTIPLE_PRODUCT,
          page: () => const OpenMultipleProductView(),
          binding: OpenMultipleProductBinding(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: _Paths.OPEN_SET_MEAL,
          page: () => const OpenSetMealView(),
          binding: OpenSetMealBinding(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: _Paths.OPEN_CUSTOMER,
          page: () => const OpenCustomerView(),
          binding: OpenCustomerBinding(),
          middlewares: [AuthMiddleware()],
        ),
      ],
    ),
    GetPage(name: _Paths.PDF, page: () => const PdfView(), binding: PdfBinding(), middlewares: [AuthMiddleware()]),
    GetPage(
      name: _Paths.MASTER,
      page: () => const MasterView(),
      binding: MasterBinding(),
      children: [
        GetPage(
          name: _Paths.CATEGORY,
          page: () => const CategoryView(),
          binding: CategoryBinding(),
          middlewares: [AuthMiddleware()],
          children: [
            GetPage(
              name: _Paths.CATEGORY_EDIT,
              page: () => const CategoryEditView(),
              binding: CategoryEditBinding(),
              middlewares: [AuthMiddleware()],
            ),
            GetPage(
              name: _Paths.CATEGORY2,
              page: () => const Category2View(),
              binding: Category2Binding(),
              middlewares: [AuthMiddleware()],
              children: [
                GetPage(
                  name: _Paths.CATEGORY2_EDIT,
                  page: () => const Category2EditView(),
                  binding: Category2EditBinding(),
                  middlewares: [AuthMiddleware()],
                ),
              ],
            ),
          ],
        ),
        GetPage(
          name: _Paths.PRODUCTS,
          page: () => const ProductsView(),
          binding: ProductsBinding(),
          middlewares: [AuthMiddleware()],
          children: [
            GetPage(
              name: _Paths.ADVANCED_SEARCH,
              page: () => const AdvancedSearchView(),
              binding: AdvancedSearchBinding(),
              middlewares: [AuthMiddleware()],
            ),
            GetPage(
              name: _Paths.PRODUCT_EDIT,
              page: () => const ProductEditView(),
              binding: ProductEditBinding(),
              middlewares: [AuthMiddleware()],
              children: [
                GetPage(
                  name: _Paths.COPY_PRODUCT_SET_MEAL,
                  page: () => const CopyProductSetMealView(),
                  binding: CopyProductSetMealBinding(),
                  middlewares: [AuthMiddleware()],
                ),
              ],
            ),
          ],
        ),
        GetPage(
          name: _Paths.PRODUCT_REMARKS,
          page: () => const ProductRemarksView(),
          binding: ProductRemarksBinding(),
          middlewares: [AuthMiddleware()],
          children: [
            GetPage(
              name: _Paths.PRODUCT_REMARKS_EDIT,
              page: () => const ProductRemarksEditView(),
              binding: ProductRemarksEditBinding(),
              middlewares: [AuthMiddleware()],
            ),
          ],
        ),
        GetPage(
          name: _Paths.CUSTOMER,
          page: () => const CustomerView(),
          binding: CustomerBinding(),
          middlewares: [AuthMiddleware()],
          children: [
            GetPage(
              name: _Paths.CUSTOMER_EDIT,
              page: () => const CustomerEditView(),
              binding: CustomerEditBinding(),
              middlewares: [AuthMiddleware()],
            ),
          ],
        ),
        GetPage(
          name: _Paths.SUPPLIER,
          page: () => const SupplierView(),
          binding: SupplierBinding(),
          middlewares: [AuthMiddleware()],
          children: [
            GetPage(
              name: _Paths.SUPPLIER_EDIT,
              page: () => const SupplierEditView(),
              binding: SupplierEditBinding(),
              middlewares: [AuthMiddleware()],
            ),
          ],
        ),
        GetPage(
          name: _Paths.STOCK,
          page: () => const StockView(),
          binding: StockBinding(),
          middlewares: [AuthMiddleware()],
          children: [
            GetPage(
              name: _Paths.STOCK_EDIT,
              page: () => const StockEditView(),
              binding: StockEditBinding(),
              middlewares: [AuthMiddleware()],
            ),
          ],
        ),
        GetPage(
          name: _Paths.CURRENCY,
          page: () => const CurrencyView(),
          binding: CurrencyBinding(),
          middlewares: [AuthMiddleware()],
          children: [
            GetPage(name: _Paths.CURRENCY_EDIT, page: () => const CurrencyEditView(), binding: CurrencyEditBinding()),
          ],
        ),
        GetPage(
          name: _Paths.UNIT,
          page: () => const UnitView(),
          binding: UnitBinding(),
          middlewares: [AuthMiddleware()],
          children: [
            GetPage(
              name: _Paths.UNIT_EDIT,
              page: () => const UnitEditView(),
              binding: UnitEditBinding(),
              middlewares: [AuthMiddleware()],
            ),
          ],
        ),
        GetPage(
          name: _Paths.SET_MENU,
          page: () => const SetMenuView(),
          binding: SetMenuBinding(),
          middlewares: [AuthMiddleware()],
          children: [
            GetPage(
              name: _Paths.SET_MENU_EDIT,
              page: () => const SetMenuEditView(),
              binding: SetMenuEditBinding(),
              middlewares: [AuthMiddleware()],
            ),
          ],
        ),
        GetPage(
          name: _Paths.DEPARTMENT,
          page: () => const DepartmentView(),
          binding: DepartmentBinding(),
          middlewares: [AuthMiddleware()],
          children: [
            GetPage(
              name: _Paths.DEPARTMENT_EDIT,
              page: () => const DepartmentEditView(),
              binding: DepartmentEditBinding(),
              middlewares: [AuthMiddleware()],
            ),
          ],
        ),
        GetPage(
          name: _Paths.PAY_METHOD,
          page: () => const PayMethodView(),
          binding: PayMethodBinding(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: _Paths.NETWORK_PAY_METHOD,
          page: () => const NetworkPayMethodView(),
          binding: NetworkPayMethodBinding(),
          middlewares: [AuthMiddleware()],
          children: [
            GetPage(
              name: _Paths.NET_WORK_PAY_METHOD_EDIT,
              page: () => const NetWorkPayMethodEditView(),
              binding: NetWorkPayMethodEditBinding(),
            ),
          ],
        ),
        GetPage(
          name: _Paths.MESA,
          page: () => const MesaView(),
          binding: MesaBinding(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: _Paths.CALENDAR,
          page: () => const CalendarView(),
          binding: CalendarBinding(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: _Paths.PRINTER,
          page: () => const PrinterView(),
          binding: PrinterBinding(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: _Paths.TIME_SALES,
          page: () => const TimeSalesView(),
          binding: TimeSalesBinding(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: _Paths.DECCA,
          page: () => const DeccaView(),
          binding: DeccaBinding(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: _Paths.SCREEN_MODE_CATEGORY,
          page: () => const ScreenModeCategoryView(),
          binding: ScreenModeCategoryBinding(),
          middlewares: [AuthMiddleware()],
        ),
      ],
    ),
    GetPage(
      name: _Paths.SUPPLIER_INVOICE,
      page: () => const SupplierInvoiceView(),
      binding: SupplierInvoiceBinding(),
      middlewares: [AuthMiddleware()],
      children: [
        GetPage(
          name: _Paths.SUPPLIER_INVOICE_EDIT,
          page: () => const SupplierInvoiceEditView(),
          binding: SupplierInvoiceEditBinding(),
        ),
      ],
    ),
    GetPage(name: _Paths.PAGE_NOT_FOUND, page: () => const PageNotFoundView(), binding: PageNotFoundBinding()),
  ];
}
