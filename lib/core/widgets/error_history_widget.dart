import 'package:flutter/material.dart';
import '../error/failures.dart';
import '../constants/app_constants.dart';
import 'error_card.dart';

class ErrorHistoryWidget extends StatelessWidget {
  final List<Failure> errors;
  final VoidCallback? onClearAll;

  const ErrorHistoryWidget({
    super.key,
    required this.errors,
    this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    if (errors.isEmpty) {
      return const Center(
        child: Text('Henüz hata kaydı bulunmuyor'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hata Geçmişi (${errors.length})',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (onClearAll != null)
                TextButton.icon(
                  onPressed: onClearAll,
                  icon: const Icon(Icons.delete_sweep),
                  label: const Text('Tümünü Temizle'),
                ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            itemCount: errors.length,
            itemBuilder: (context, index) {
              final error = errors[errors.length - 1 - index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ErrorCard(
                  message: error.message,
                  details: error.formattedError,
                  failure: error,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
