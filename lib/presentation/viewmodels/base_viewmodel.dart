import 'package:flutter/foundation.dart';

abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  @protected
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  @protected
  void setError(String? error) {
    _error = error;
    notifyListeners();
  }
}
