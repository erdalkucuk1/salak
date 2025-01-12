import 'package:flutter/foundation.dart';

abstract class Failure {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;
  final DateTime timestamp;
  final Map<String, dynamic>? additionalData;

  Failure({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
    this.additionalData,
  }) : timestamp = DateTime.now();

  String get formattedError {
    final buffer = StringBuffer();
    buffer.writeln('🚨 HATA DETAYLARI:');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('📅 Zaman: ${_formatDateTime(timestamp)}');
    buffer.writeln('📝 Mesaj: $message');

    if (code != null) {
      buffer.writeln('🏷️ Kod: $code');
    }

    if (additionalData?.isNotEmpty ?? false) {
      buffer.writeln('\n📊 Ek Bilgiler:');
      additionalData!.forEach((key, value) {
        buffer.writeln('  • $key: $value');
      });
    }

    if (kDebugMode) {
      if (originalError != null) {
        buffer.writeln('\n⚠️ Orijinal Hata:');
        buffer.writeln(originalError.toString());
      }

      if (stackTrace != null) {
        buffer.writeln('\n📍 Stack Trace:');
        buffer.writeln(stackTrace.toString());
      }
    }

    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    return buffer.toString();
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }

  String get aiErrorFormat {
    final buffer = StringBuffer();
    buffer.writeln('### AI ERROR ANALYSIS');
    buffer.writeln('```json');
    buffer.writeln('{');
    buffer.writeln('  "error_type": "${runtimeType.toString()}",');
    buffer.writeln('  "timestamp": "${timestamp.toIso8601String()}",');
    buffer.writeln('  "error_code": ${code != null ? '"$code"' : 'null'},');
    buffer.writeln('  "message": "$message",');

    if (additionalData?.isNotEmpty ?? false) {
      buffer.writeln('  "context": {');
      additionalData!.forEach((key, value) {
        final sanitizedValue = value.toString().replaceAll('"', '\\"');
        buffer.writeln(
            '    "$key": "$sanitizedValue"${additionalData!.keys.last == key ? '' : ','}');
      });
      buffer.writeln('  },');
    }

    if (originalError != null) {
      buffer.writeln(
          '  "original_error": "${originalError.toString().replaceAll('"', '\\"')}",');
    }

    if (stackTrace != null) {
      final stackLines = stackTrace
          .toString()
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .take(5) // İlk 5 satır
          .toList();

      buffer.writeln('  "stack_trace": [');
      for (var i = 0; i < stackLines.length; i++) {
        final line = stackLines[i].replaceAll('"', '\\"');
        buffer.writeln('    "$line"${i == stackLines.length - 1 ? '' : ','}');
      }
      buffer.writeln('  ],');
    }

    buffer.writeln('  "suggestions": [');
    buffer.writeln(
        '    "Analyze this error and provide detailed solution steps",');
    buffer.writeln('    "Check for similar patterns in error history",');
    buffer.writeln('    "Suggest preventive measures"');
    buffer.writeln('  ]');

    buffer.writeln('}');
    buffer.writeln('```');
    return buffer.toString();
  }

  @override
  String toString() => formattedError;
}

class NetworkFailure extends Failure {
  final int? statusCode;
  final String? endpoint;
  final Map<String, dynamic>? responseData;
  final String? requestMethod;
  final Map<String, dynamic>? requestData;

  NetworkFailure({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
    this.statusCode,
    this.endpoint,
    this.responseData,
    this.requestMethod,
    this.requestData,
  }) : super(
          additionalData: {
            if (statusCode != null) 'Status Kodu': statusCode,
            if (endpoint != null) 'Endpoint': endpoint,
            if (requestMethod != null) 'İstek Metodu': requestMethod,
            if (requestData != null) 'İstek Verisi': requestData,
            if (responseData != null) 'Yanıt Verisi': responseData,
          },
        );
}

class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;
  final String? validationType;
  final dynamic invalidValue;

  ValidationFailure({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
    this.fieldErrors,
    this.validationType,
    this.invalidValue,
  }) : super(
          additionalData: {
            if (fieldErrors != null) 'Alan Hataları': fieldErrors,
            if (validationType != null) 'Doğrulama Tipi': validationType,
            if (invalidValue != null) 'Geçersiz Değer': invalidValue,
          },
        );
}

class AuthFailure extends Failure {
  final AuthErrorType type;
  final String? userId;
  final String? sessionId;

  AuthFailure({
    required super.message,
    required this.type,
    super.code,
    super.originalError,
    super.stackTrace,
    this.userId,
    this.sessionId,
  }) : super(
          additionalData: {
            'Hata Tipi': type.name,
            if (userId != null) 'Kullanıcı ID': userId,
            if (sessionId != null) 'Oturum ID': sessionId,
          },
        );
}

class CacheFailure extends Failure {
  final String? key;
  final CacheOperation operation;
  final String? storageType;

  CacheFailure({
    required super.message,
    required this.operation,
    super.code,
    super.originalError,
    super.stackTrace,
    this.key,
    this.storageType,
  }) : super(
          additionalData: {
            'İşlem': operation.name,
            if (key != null) 'Anahtar': key,
            if (storageType != null) 'Depolama Tipi': storageType,
          },
        );
}

class UnexpectedFailure extends Failure {
  final String? source;
  final String? errorType;

  UnexpectedFailure({
    super.message = 'Beklenmeyen bir hata oluştu',
    super.code = 'UNEXPECTED_ERROR',
    super.originalError,
    super.stackTrace,
    this.source,
    this.errorType,
    super.additionalData,
  }) : super();
}

enum AuthErrorType {
  invalidCredentials('Geçersiz kimlik bilgileri'),
  userNotFound('Kullanıcı bulunamadı'),
  sessionExpired('Oturum süresi doldu'),
  unauthorized('Yetkisiz erişim'),
  other('Diğer kimlik doğrulama hatası');

  final String message;
  const AuthErrorType(this.message);
}

enum CacheOperation {
  read('Okuma'),
  write('Yazma'),
  delete('Silme'),
  clear('Temizleme');

  final String message;
  const CacheOperation(this.message);
}
