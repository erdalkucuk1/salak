import 'package:flutter/material.dart';

enum NotificationType {
  info,
  success,
  warning,
  error,
}

class NotificationModel {
  final String message;
  final NotificationType type;
  final Duration? duration;
  final VoidCallback? action;
  final String? actionLabel;
  final bool dismissible;
  final DateTime createdAt;

  NotificationModel({
    required this.message,
    this.type = NotificationType.info,
    this.duration = const Duration(seconds: 4),
    this.action,
    this.actionLabel,
    this.dismissible = true,
  }) : createdAt = DateTime.now();

  Color get color {
    switch (type) {
      case NotificationType.success:
        return Colors.green;
      case NotificationType.warning:
        return Colors.orange;
      case NotificationType.error:
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  IconData get icon {
    switch (type) {
      case NotificationType.success:
        return Icons.check_circle;
      case NotificationType.warning:
        return Icons.warning;
      case NotificationType.error:
        return Icons.error;
      default:
        return Icons.info;
    }
  }
}
