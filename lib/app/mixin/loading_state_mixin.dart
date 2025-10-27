import 'package:get/get.dart';

mixin LoadingStateMixin<T> on GetxController {
  final RxString _title = ''.obs;
  final RxBool _isLoading = false.obs;
  final RxInt _totalPages = 0.obs;
  final RxInt _currentPage = 1.obs;
  final RxInt _totalRecords = 0.obs;
  final RxBool _hasPermission = true.obs;
  final RxString _error = ''.obs;
  final RxBool _success = false.obs;
  final Rxn<T> _data = Rxn<T>();

  @override
  void onClose() {
    _data.value = null;
    super.onClose();
  }

  //  ===== Getter & Setter =====
  String get title => _title.value;
  set title(String value) => _title.value = value;

  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  int get totalPages => _totalPages.value;
  set totalPages(int value) => _totalPages.value = value;

  int get currentPage => _currentPage.value;
  set currentPage(int value) => _currentPage.value = value;

  int get totalRecords => _totalRecords.value;
  set totalRecords(int value) => _totalRecords.value = value;

  bool get hasPermission => _hasPermission.value;
  set hasPermission(bool value) => _hasPermission.value = value;

  String get error => _error.value;
  set error(String value) => _error.value = value;

  bool get success => _success.value;
  set success(bool value) => _success.value = value;

  T? get data => _data.value;
  set data(T? value) => _data.value = value;
}
