import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../config.dart';
import '../routes/app_pages.dart';
import '../utils/stroage_manage.dart';

class PopupLang extends StatefulWidget {
  const PopupLang({super.key});

  @override
  State<PopupLang> createState() => _PopupLangState();
}

class _PopupLangState extends State<PopupLang> {
  @override
  Widget build(BuildContext context) {
    final StorageManage storageManage = StorageManage();
    return PopupMenuButton(
      icon: Icon(FontAwesomeIcons.language),
      itemBuilder: (BuildContext context) {
        final String currentLanguage = storageManage.read(Config.localStroagelanguage);
        return <PopupMenuEntry<String>>[
          PopupMenuItem(
            value: "zh_CN",
            child: Text("中文简体", style: TextStyle(color: currentLanguage == "zh_CN" ? Colors.green : null)),
          ),
          PopupMenuDivider(),
          PopupMenuItem(
            value: "zh_HK",
            child: Text("中文繁體", style: TextStyle(color: currentLanguage == "zh_HK" ? Colors.green : null)),
          ),
          PopupMenuDivider(),
          PopupMenuItem(
            value: "en_US",
            child: Text("English", style: TextStyle(color: currentLanguage == "en_US" ? Colors.green : null)),
          ),
        ];
      },
      onSelected: (String value) {
        final locale = switch (value) {
          "zh_CN" => const Locale("zh", "CN"),
          "zh_HK" => const Locale("zh", "HK"),
          _ => const Locale("en", "US"),
        };
        storageManage.write(Config.localStroagelanguage, value);
        Get.updateLocale(locale);
        if (Get.currentRoute != Routes.SIGNIN) {
          Get.offAndToNamed(Routes.REFRESH_TEMP, arguments: Get.currentRoute);
        }
      },
    );
  }
}
