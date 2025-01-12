import 'package:flutter/material.dart';

class BasePage extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool hasScroll;
  final EdgeInsets? padding;

  const BasePage({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.hasScroll = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = body;

    if (hasScroll) {
      content = SingleChildScrollView(
        child: content,
      );
    }

    if (padding != null) {
      content = Padding(
        padding: padding!,
        child: content,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
      ),
      body: content,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
