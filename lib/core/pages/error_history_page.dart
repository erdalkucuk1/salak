import 'package:flutter/material.dart';
import '../widgets/base_page.dart';
import '../widgets/error_history_widget.dart';
import '../error/error_handler.dart';

class ErrorHistoryPage extends StatelessWidget {
  const ErrorHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Hata Geçmişi',
      hasScroll: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Hata Geçmişi Hakkında'),
                content: const Text(
                  'Bu sayfa uygulamada meydana gelen hataların kaydını tutar. '
                  'Her hata detaylı bilgiler içerir ve AI analizi için uygun formatta sunulur.\n\n'
                  'Hataları inceleyebilir, kopyalayabilir ve AI asistanından yardım alabilirsiniz.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Anladım'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
      body: ErrorHistoryWidget(
        errors: ErrorHandler.errorHistory,
        onClearAll: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Hata Geçmişini Temizle'),
              content: const Text(
                'Tüm hata kayıtları silinecek. Bu işlem geri alınamaz.\n'
                'Devam etmek istiyor musunuz?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('İptal'),
                ),
                TextButton(
                  onPressed: () {
                    ErrorHandler.clearHistory();
                    Navigator.pop(context);
                  },
                  child: const Text('Temizle'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
