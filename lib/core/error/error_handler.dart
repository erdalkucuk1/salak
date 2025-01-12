import 'package:flutter/material.dart';
import 'failures.dart';
import '../extensions/context_extension.dart';
import '../utils/logger.dart';
import 'package:flutter/services.dart';
import '../widgets/error_card.dart';

class ErrorHandler {
  static final List<Failure> _errorHistory = [];
  static bool _isHandlingError = false;

  static List<Failure> get errorHistory => List.unmodifiable(_errorHistory);

  static void handleError(
    BuildContext context,
    dynamic error, {
    bool showDialog = false,
    VoidCallback? onRetry,
    bool addToHistory = true,
  }) {
    if (_isHandlingError) return;
    _isHandlingError = true;

    try {
      final failure = _convertToFailure(error);

      if (addToHistory) {
        _addToHistory(failure);
      }

      _logError(failure);

      if (showDialog) {
        _showErrorDialog(context, failure, onRetry: onRetry);
      } else {
        context.showSnackBar(failure.message, isError: true);
      }
    } finally {
      _isHandlingError = false;
    }
  }

  static Failure _convertToFailure(dynamic error) {
    if (error is Failure) return error;

    if (error is Exception) {
      return ValidationFailure(
        message: error.toString(),
        originalError: error,
        stackTrace: StackTrace.current,
      );
    }

    return UnexpectedFailure(
      originalError: error,
      stackTrace: StackTrace.current,
    );
  }

  static void _addToHistory(Failure failure) {
    _errorHistory.add(failure);
    if (_errorHistory.length > 10) {
      _errorHistory.removeAt(0);
    }
  }

  static void _logError(Failure failure) {
    Logger.error(
      failure.toString(),
      error: failure.originalError,
      stackTrace: failure.stackTrace,
    );
  }

  static void _showErrorDialog(
    BuildContext context,
    Failure failure, {
    VoidCallback? onRetry,
  }) {
    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: ErrorCard(
          message: failure.message,
          details: failure.toString() +
              (failure.stackTrace != null
                  ? '\n\nStack Trace:\n${failure.stackTrace}'
                  : ''),
          onRetry: onRetry,
        ),
      ),
    );
  }

  static Future<T?> wrap<T>({
    required BuildContext context,
    required Future<T> Function() task,
    String? loadingMessage,
    bool showDialog = false,
    bool addToHistory = true,
    VoidCallback? onRetry,
  }) async {
    try {
      final result = await task();
      if (!context.mounted) return null;
      return result;
    } catch (error, stackTrace) {
      final failure = error is Failure
          ? error
          : UnexpectedFailure(
              originalError: error,
              stackTrace: stackTrace,
              source: 'ErrorHandler.wrap',
              errorType: error.runtimeType.toString(),
            );

      final currentContext = context;
      if (!currentContext.mounted) return null;

      handleError(
        currentContext,
        failure,
        showDialog: showDialog,
        onRetry: onRetry,
        addToHistory: addToHistory,
      );

      if (currentContext.mounted) {
        await analyzeError(currentContext, failure);
      }

      return null;
    }
  }

  static void clearHistory() {
    _errorHistory.clear();
  }

  static Future<void> analyzeError(
    BuildContext context,
    Failure failure,
  ) async {
    if (!context.mounted) return;

    final aiErrorFormat = failure.aiErrorFormat;

    Logger.error(
      'AI Error Analysis Format:',
      error: aiErrorFormat,
    );

    final currentContext = context;
    final navigator = Navigator.of(currentContext);
    final scaffoldMessenger = ScaffoldMessenger.of(currentContext);

    await Clipboard.setData(ClipboardData(text: aiErrorFormat));

    if (!currentContext.mounted) return;

    showDialog(
      context: currentContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text('AI Hata Analizi'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hata analizi için AI formatı hazırlandı ve panoya kopyalandı.\n'
                'Bu formatı bir AI asistanına ileterek detaylı çözüm önerileri alabilirsiniz.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  aiErrorFormat
                      .replaceAll('### AI ERROR ANALYSIS\n```json\n', '')
                      .replaceAll('\n```', ''),
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => navigator.pop(),
            child: const Text('Kapat'),
          ),
          TextButton.icon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: aiErrorFormat));
              navigator.pop();
              scaffoldMessenger.showSnackBar(
                const SnackBar(content: Text('AI hata formatı kopyalandı')),
              );
            },
            icon: const Icon(Icons.copy),
            label: const Text('Kopyala'),
          ),
        ],
      ),
    );
  }
}
