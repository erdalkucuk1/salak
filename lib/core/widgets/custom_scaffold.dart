import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool hasScroll;
  final EdgeInsetsGeometry? padding;
  final PreferredSizeWidget? appBar;
  final Color? backgroundColor;

  const CustomScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.hasScroll = true,
    this.padding,
    this.appBar,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = body;

    if (hasScroll) {
      content = SingleChildScrollView(child: content);
    }

    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar ??
          AppBar(
            title: Text(title),
            actions: actions,
            centerTitle: true,
          ),
      body: content,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
