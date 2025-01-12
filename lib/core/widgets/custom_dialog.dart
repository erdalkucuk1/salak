import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? actions;
  final bool barrierDismissible;
  final EdgeInsetsGeometry? contentPadding;

  const CustomDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions,
    this.barrierDismissible = true,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: content,
      ),
      contentPadding:
          contentPadding ?? const EdgeInsets.all(AppConstants.defaultPadding),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius * 2),
      ),
      actions: actions,
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    List<Widget>? actions,
    bool barrierDismissible = true,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => CustomDialog(
        title: title,
        content: content,
        actions: actions,
        barrierDismissible: barrierDismissible,
        contentPadding: contentPadding,
      ),
    );
  }
}
