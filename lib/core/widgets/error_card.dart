import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';
import '../error/error_handler.dart';
import '../error/failures.dart';

class ErrorCard extends StatelessWidget {
  final String message;
  final String? details;
  final VoidCallback? onRetry;
  final Failure? failure;

  const ErrorCard({
    super.key,
    required this.message,
    this.details,
    this.onRetry,
    this.failure,
  });

  Future<void> _copyToClipboard(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hata detayları kopyalandı')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.error, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (details != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  details!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (details != null)
                  TextButton.icon(
                    onPressed: () => _copyToClipboard(context, details!),
                    icon: const Icon(Icons.copy),
                    label: const Text('Kopyala'),
                  ),
                if (failure != null) ...[
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () {
                      if (context.mounted) {
                        ErrorHandler.analyzeError(context, failure!);
                      }
                    },
                    icon: const Icon(Icons.psychology),
                    label: const Text('AI Analizi'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.deepPurple,
                    ),
                  ),
                ],
                if (onRetry != null) ...[
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tekrar Dene'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
