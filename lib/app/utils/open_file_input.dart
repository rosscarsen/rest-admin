import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../translations/locale_keys.dart';
import 'custom_dialog.dart';

class OpenFileInput extends StatefulWidget {
  final String name;
  final String labelText;
  final TextEditingController? controller;
  final void Function(File? file)? onFileSelected;
  final List<String> allowedExtensions;
  final IconData prefixIcon;
  final bool readOnly;

  const OpenFileInput({
    super.key,
    required this.name,
    required this.labelText,
    this.controller,
    this.onFileSelected,
    this.allowedExtensions = const ['xlsx', 'xls'],
    this.prefixIcon = Icons.file_open,
    this.readOnly = true,
  });

  @override
  State<OpenFileInput> createState() => _OpenFileInputState();
}

class _OpenFileInputState extends State<OpenFileInput> {
  late TextEditingController _controller;
  final ValueNotifier<File?> _selectedFileNotifier = ValueNotifier(null);
  final ValueNotifier<bool> _isPickingNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    // 监听控制器变化，同步清除操作
    _controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(OpenFileInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _controller.removeListener(_onControllerChanged);
      _controller = widget.controller ?? TextEditingController();
      _controller.addListener(_onControllerChanged);
    }
  }

  void _onControllerChanged() {
    if (_controller.text.isEmpty && _selectedFileNotifier.value != null) {
      _selectedFileNotifier.value = null;
    }
  }

  Future<void> _pickFile() async {
    if (_isPickingNotifier.value) return;

    _isPickingNotifier.value = true;

    try {
      final FilePickerResult? result = await _showFilePicker().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          _showToast(LocaleKeys.pickerTimeout.tr);
          return null;
        },
      );

      await _handlePickerResult(result);
    } catch (e) {
      debugPrint('File picker error: $e');
      _showToast(LocaleKeys.pickerFailed.tr);
    } finally {
      _isPickingNotifier.value = false;
    }
  }

  Future<FilePickerResult?> _showFilePicker() async {
    return await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: widget.allowedExtensions,
      dialogTitle: widget.labelText,
      lockParentWindow: true,
      withData: false,
      withReadStream: false,
    );
  }

  Future<void> _handlePickerResult(FilePickerResult? result) async {
    if (result == null) {
      _showToast(LocaleKeys.userCanceledPicker.tr);
      return;
    }

    if (result.files.isEmpty) {
      _showToast(LocaleKeys.noFileSelected.tr);
      return;
    }

    final PlatformFile platformFile = result.files.first;
    if (platformFile.path == null) {
      _showToast(LocaleKeys.invalidFilePath.tr);
      return;
    }

    final file = File(platformFile.path!);
    if (!await file.exists()) {
      _showToast(LocaleKeys.fileNotFound.tr);
      return;
    }

    // 更新UI
    _controller.text = platformFile.name;
    _selectedFileNotifier.value = file;

    // 回调
    widget.onFileSelected?.call(file);
  }

  void _clearSelection() {
    _controller.clear();
    _selectedFileNotifier.value = null;
    widget.onFileSelected?.call(null);
  }

  void _showToast(String message) {
    CustomDialog.showToast(message);
  }

  Widget _buildSuffixIcon(bool isPicking, bool hasText) {
    if (isPicking) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)),
        ),
      );
    }

    if (hasText) {
      return IconButton(
        icon: const Icon(Icons.clear, size: 20),
        onPressed: _clearSelection,
        splashRadius: 18,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      );
    }

    return IconButton(
      tooltip: widget.labelText,
      onPressed: _pickFile,
      icon: const Icon(Icons.file_open, size: 20),
      splashRadius: 18,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isPickingNotifier,
      builder: (context, isPicking, _) {
        return ValueListenableBuilder<File?>(
          valueListenable: _selectedFileNotifier,
          builder: (context, selectedFile, _) {
            final hasText = _controller.text.isNotEmpty;
            return TextField(
              readOnly: widget.readOnly,
              controller: _controller,
              onTap: isPicking ? null : _pickFile,
              enabled: !isPicking,
              decoration: InputDecoration(
                hintText: widget.labelText,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                prefixIcon: Icon(widget.prefixIcon, color: isPicking ? Colors.grey : Colors.blue),
                suffixIcon: _buildSuffixIcon(isPicking, hasText),
                border: const OutlineInputBorder(),
                filled: isPicking,
                fillColor: isPicking ? Colors.grey[50] : null,
                isDense: true,
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _isPickingNotifier.dispose();
    _selectedFileNotifier.dispose();
    _controller.removeListener(_onControllerChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }

    super.dispose();
  }
}
