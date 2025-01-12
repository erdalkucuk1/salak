import 'package:flutter/material.dart';
import '../error/failures.dart';
import '../utils/logger.dart';

class FormProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _email = '';
  String get email => _email;

  Failure? _lastError;
  Failure? get lastError => _lastError;

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  Future<bool> submitForm() async {
    try {
      _isLoading = true;
      _lastError = null;
      notifyListeners();

      Logger.info('Form gönderiliyor...');
      await Future.delayed(const Duration(milliseconds: 300));

      if (_email.contains('error')) {
        throw NetworkFailure(
          message: 'Form gönderilirken bir hata oluştu',
          code: 'API_ERROR_503',
          statusCode: 503,
          endpoint: '/api/submit',
          requestMethod: 'POST',
          requestData: {'email': _email},
          responseData: {
            'error': 'Service Unavailable',
            'timestamp': DateTime.now().toIso8601String(),
          },
        );
      }

      if (_email.contains('auth')) {
        throw AuthFailure(
          message: 'Oturum süreniz doldu',
          type: AuthErrorType.sessionExpired,
          code: 'AUTH_ERROR_401',
          userId: 'user_123',
          sessionId: 'session_xyz',
        );
      }

      if (_email.contains('validation')) {
        throw ValidationFailure(
          message: 'Form doğrulama hatası',
          code: 'VALIDATION_ERROR',
          validationType: 'email',
          invalidValue: _email,
          fieldErrors: {
            'email': 'Geçersiz email formatı',
          },
        );
      }

      Logger.info('Form başarıyla gönderildi');
      return true;
    } catch (e) {
      if (e is Failure) {
        _lastError = e;
      } else {
        _lastError = UnexpectedFailure(
          originalError: e,
          stackTrace: StackTrace.current,
          source: 'FormProvider.submitForm',
          errorType: e.runtimeType.toString(),
        );
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _lastError = null;
    notifyListeners();
  }
}
