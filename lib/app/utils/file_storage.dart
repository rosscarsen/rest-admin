import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_file_saver/flutter_file_saver.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../translations/locale_keys.dart';
import 'custom_alert.dart';
import 'custom_dialog.dart';

enum DownloadFileType { Excel, Pdf }

// 将文件保存在设备中
class FileStorage {
  /// 保存文件到下载目录
  static Future saveFileToDownloads({
    required Uint8List bytes,
    required String fileName,
    required DownloadFileType fileType,
  }) async {
    if (Platform.isWindows || Platform.isLinux) {
      final Directory? directory = await getDownloadsDirectory();
      if (directory == null) {
        CustomDialog.showToast(LocaleKeys.filePathError.tr);
        return;
      }
      final String path = directory.path;
      final file = File(join(path, fileName));
      final ret = await file.writeAsBytes(bytes);
      if (ret.existsSync()) {
        CustomAlert.iosAlert(
          message: LocaleKeys.thisFileHasBeenSavedTo.tr.trArgs([file.path]),
          confirmText: LocaleKeys.copy.tr,
          onConfirm: () {
            Clipboard.setData(ClipboardData(text: file.path));
            CustomDialog.showToast(LocaleKeys.copySuccess.tr);
          },
          showCancel: true,
        );
      } else {
        CustomDialog.showToast(LocaleKeys.fileDownloadFailed.tr);
      }
    } else {
      try {
        await FlutterFileSaver().writeFileAsBytes(fileName: fileName, bytes: bytes);
      } catch (e) {
        CustomDialog.showToast(LocaleKeys.operationWasCancelled.tr);
      }
    }
  }
}
