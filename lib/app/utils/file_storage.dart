import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_saver/flutter_file_saver.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../translations/locale_keys.dart';
import 'custom_alert.dart';
import 'easy_loading.dart';

// 将文件保存在设备中
enum FileType { Excel, Pdf }

class FileStorage {
  /// 保存文件到下载目录
  static Future saveFileToDownloads({
    required Uint8List bytes,
    required String fileName,
    required FileType fileType,
  }) async {
    if (!kIsWeb) {
      if (Platform.isWindows || Platform.isLinux) {
        final Directory? directory = await getDownloadsDirectory();
        if (directory == null) {
          showToast(LocaleKeys.filePathError.tr);
          return;
        }
        final String path = directory.path;
        final file = File(join(path, fileName));
        final ret = await file.writeAsBytes(bytes);
        if (ret.existsSync()) {
          CustomAlert.iosAlert(
            LocaleKeys.thisFileHasBeenSavedTo.tr.trArgs([file.path]),
            confirmText: LocaleKeys.copy.tr,
            onConfirm: () {
              Clipboard.setData(ClipboardData(text: file.path));
              showToast(LocaleKeys.copySuccess.tr);
            },
            showCancel: true,
          );
        } else {
          showToast(LocaleKeys.fileDownloadFailed.tr);
        }
      } else {
        try {
          await FlutterFileSaver().writeFileAsBytes(fileName: fileName, bytes: bytes);
        } catch (e) {
          showToast(LocaleKeys.operationWasCancelled.tr);
        }
      }
    } else {
      if (fileType == FileType.Pdf) {
        try {
          await FlutterFileSaver().writeFileAsBytes(fileName: fileName, bytes: bytes);
        } catch (e) {
          showToast(LocaleKeys.operationWasCancelled.tr);
        }
      }
    }
  }
}
