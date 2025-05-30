import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';
import '../translations/locale_keys.dart';
import 'popup_lang.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({super.key, required this.route, required this.body, this.actions, required this.title});

  final Widget body;
  final String route;
  final List<Widget>? actions;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      leadingIcon: Icon(Icons.menu),
      appBar: AppBar(
        title: Text(title.tr),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [PopupLang(), if (actions != null) ...actions!],
      ),
      sideBar: SideBar(
        backgroundColor: const Color(0xFFEEEEEE),
        borderColor: const Color(0xFFE7E7E7),
        iconColor: Color.fromARGB(234, 68, 68, 68),
        activeIconColor: Theme.of(context).primaryColor,
        textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Color.fromARGB(234, 68, 68, 68)),
        activeTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).primaryColor),
        items: [
          // 仪表盘
          AdminMenuItem(title: LocaleKeys.salesView.tr, route: Routes.DASHBOARD, icon: FontAwesomeIcons.gauge),
          // 主档
          AdminMenuItem(
            title: LocaleKeys.master.tr,
            icon: FontAwesomeIcons.ccMastercard,
            children: [
              // 产品
              AdminMenuItem(title: LocaleKeys.product.tr, route: Routes.PRODUCTS, icon: FontAwesomeIcons.productHunt),
              // 类目
              AdminMenuItem(title: LocaleKeys.category.tr, route: Routes.CATEGORY, icon: Icons.category),
              // 食品备注
              AdminMenuItem(
                title: LocaleKeys.productRemarks.tr,
                route: Routes.PRODUCT_REMARKS,
                icon: FontAwesomeIcons.mars,
              ),
            ],
          ),
          // 供应商发票
          AdminMenuItem(
            title: LocaleKeys.supplierInvoice.tr,
            icon: FontAwesomeIcons.supple,
            route: Routes.SUPPLIER_INVOICE,
          ),
        ],
        selectedRoute: route,
        onSelected: (item) {
          debugPrint('sideBar: onTap(): title = ${item.title}, route = ${item.route}');
          if (item.route != null && item.route != route) {
            Get.offAndToNamed(item.route!);
          }
        },
        /*  header: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: const Center(
            child: Text('header', style: TextStyle(color: Colors.white)),
          ),
        ), */
        footer: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: const Center(
            child: Text('footer', style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
      body: body,
    );
  }
}
