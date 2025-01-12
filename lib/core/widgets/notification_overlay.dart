import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/notification_model.dart';
import '../providers/notification_provider.dart';
import '../constants/app_constants.dart';
import 'package:flutter/services.dart';

class NotificationOverlay extends StatelessWidget {
  final Widget child;

  const NotificationOverlay({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          top: AppConstants.defaultPadding,
          left: AppConstants.defaultPadding,
          right: AppConstants.defaultPadding,
          child: Consumer<NotificationProvider>(
            builder: (context, provider, _) {
              return Column(
                children: provider.notifications.map((notification) {
                  return _NotificationCard(
                    notification: notification,
                    onDismiss: () => provider.remove(notification),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onDismiss;

  const _NotificationCard({
    required this.notification,
    required this.onDismiss,
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
          child: Container(
            color: notification.color.withAlpha((0.1 * 255).toInt()),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(
                    notification.icon,
                    color: notification.color,
                  ),
                  title: Text(notification.message),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (notification.type == NotificationType.error)
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () => _copyToClipboard(
                            context,
                            notification.message,
                          ),
                          tooltip: 'Hatayı Kopyala',
                        ),
                      if (notification.dismissible)
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: onDismiss,
                        ),
                    ],
                  ),
                  onTap: notification.action,
                ),
                if (notification.type == NotificationType.error &&
                    notification.actionLabel != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: notification.action,
                          child: Text(notification.actionLabel!),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
