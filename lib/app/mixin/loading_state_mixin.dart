import 'package:get/get.dart';

mixin LoadingStateMixin<T> on GetxController {
  late final RxString _title;
  late final RxBool _isLoading;
  late final RxInt _totalPages;
  late final RxInt _currentPage;
  late final RxInt _totalRecords;
  late final RxBool _hasPermission;
  late final RxString _error;
  late final RxBool _success;
  late final Rxn<T> _data;

  @override
  void onInit() {
    _title = ''.obs;
    _isLoading = false.obs;
    _totalPages = 0.obs;
    _currentPage = 1.obs; // 默认 1-based
    _totalRecords = 0.obs;
    _hasPermission = true.obs;
    _error = ''.obs;
    _success = false.obs;
    _data = Rxn<T>();
    super.onInit();
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
