class DioApiResult<T> {
  final bool success;
  final bool hasPermission;
  final T? data;
  final String? error;
  final String? fileName;

  DioApiResult({required this.success, this.hasPermission = true, this.data, this.error, this.fileName});

  @override
  String toString() => 'ApiResult(success: $success, data: $data, error: $error, fileName: $fileName)';
}
