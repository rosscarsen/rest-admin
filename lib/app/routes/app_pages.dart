import 'package:get/get.dart';

import '../Middlewares/auth_middleware.dart';
import '../modules/dashboard/dashboard_binding.dart';
import '../modules/dashboard/dashboard_view.dart';
import '../modules/master/category/category2/category2_binding.dart';
import '../modules/master/category/category2/category2_edit/category2_edit_binding.dart';
import '../modules/master/category/category2/category2_edit/category2_edit_view.dart';
import '../modules/master/category/category2/category2_view.dart';
import '../modules/master/category/category_binding.dart';
import '../modules/master/category/category_edit/category_edit_binding.dart';
import '../modules/master/category/category_edit/category_edit_view.dart';
import '../modules/master/category/category_view.dart';
import '../modules/master/master_binding.dart';
import '../modules/master/master_view.dart';
import '../modules/master/product_remarks/product_remarks_binding.dart';
import '../modules/master/product_remarks/product_remarks_view.dart';
import '../modules/master/products/advancedSearch/advanced_search_binding.dart';
import '../modules/master/products/advancedSearch/advanced_search_view.dart';
import '../modules/master/products/product_edit/copy_product_set_meal/copy_product_set_meal_binding.dart';
import '../modules/master/products/product_edit/copy_product_set_meal/copy_product_set_meal_view.dart';
import '../modules/master/products/product_edit/product_edit_binding.dart';
import '../modules/master/products/product_edit/product_edit_view.dart';
import '../modules/master/products/products_binding.dart';
import '../modules/master/products/products_view.dart';
import '../modules/open/open_binding.dart';
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
import '../modules/pdf/pdf_binding.dart';
import '../modules/pdf/pdf_view.dart';
import '../modules/signin/signin_binding.dart';
import '../modules/signin/signin_view.dart';
import '../modules/supplier_invoice/supplier_invoice_binding.dart';
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
        ),
      ],
    ),
    GetPage(
      name: _Paths.SUPPLIER_INVOICE,
      page: () => const SupplierInvoiceView(),
      binding: SupplierInvoiceBinding(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
