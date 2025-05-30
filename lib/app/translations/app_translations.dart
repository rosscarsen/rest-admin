import 'package:get/get.dart';

import 'en_us.dart';
import 'zh_cn.dart';
import 'zh_hk.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'zh_HK': zhHK, 'zh_CN': zhCN, 'en_US': enUS};
}
