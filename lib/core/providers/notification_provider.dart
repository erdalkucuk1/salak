import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../utils/logger.dart';

class NotificationProvider extends ChangeNotifier {
  final List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications =>
      List.unmodifiable(_notifications);

  void show({
    required String message,
    NotificationType type = NotificationType.info,
    Duration? duration,
    VoidCallback? action,
    String? actionLabel,
    bool dismissible = true,
  }) {
    final notification = NotificationModel(
      message: message,
      type: type,
      duration: duration,
      action: action,
      actionLabel: actionLabel,
      dismissible: dismissible,
    );

    _notifications.add(notification);
    notifyListeners();

    Logger.info('Bildirim gösteriliyor: ${notification.message}');

    if (duration != null) {
      _scheduleRemoval(notification);
    }
  }

  void showSuccess(
    String message, {
    Duration? duration,
    VoidCallback? action,
    String? actionLabel,
  }) {
    show(
      message: message,
      type: NotificationType.success,
      duration: duration,
      action: action,
      actionLabel: actionLabel,
    );
  }

  void showError(
    String message, {
    Duration? duration,
    VoidCallback? action,
    String? actionLabel,
  }) {
    show(
      message: message,
      type: NotificationType.error,
      duration: duration,
      action: action,
      actionLabel: actionLabel,
    );
  }

  void showWarning(
    String message, {
    Duration? duration,
    VoidCallback? action,
    String? actionLabel,
  }) {
    show(
      message: message,
      type: NotificationType.warning,
      duration: duration,
      action: action,
      actionLabel: actionLabel,
    );
  }

  void remove(NotificationModel notification) {
    _notifications.remove(notification);
    notifyListeners();
  }

  void removeAll() {
    _notifications.clear();
    notifyListeners();
  }

  void _scheduleRemoval(NotificationModel notification) {
    Future.delayed(notification.duration!).then((_) {
      if (_notifications.contains(notification)) {
        remove(notification);
      }
    });
  }
}
