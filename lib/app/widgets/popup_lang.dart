import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../config.dart';
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
      icon: Icon(Icons.settings),
      itemBuilder: (BuildContext context) {
        final String currentLanguage = storageManage.read(Config.localStroagelanguage);
        return <PopupMenuEntry<String>>[
          PopupMenuItem(
            value: "zh_CN",
            child: Text("中文简体", style: TextStyle(color: currentLanguage == "zh_CN" ? Colors.green : null)),
          ),
          PopupMenuDivider(),
          PopupMenuItem(
            value: "zh_TW",
            child: Text("中文繁體", style: TextStyle(color: currentLanguage == "zh_TW" ? Colors.green : null)),
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
          "zh_TW" => const Locale("zh", "TW"),
          _ => const Locale("en", "US"),
        };
        Get.updateLocale(locale);
        Intl.defaultLocale = value; // 更新默认语言
        storageManage.write(Config.localStroagelanguage, value);
      },
    );
  }
}
