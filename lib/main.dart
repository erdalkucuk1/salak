import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_constants.dart';
import 'core/home.dart';
import 'core/init/core_init.dart';
import 'core/providers/form_provider.dart';
import 'core/providers/notification_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/language_provider.dart';
import 'core/widgets/notification_overlay.dart';
import 'core/lang/lang_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CoreInit.init();
  await LangManager.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FormProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConstants.getText(context, 'appName'),
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness:
                themeProvider.isDark ? Brightness.dark : Brightness.light,
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            scrolledUnderElevation: 0,
          ),
          cardTheme: CardTheme(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          snackBarTheme: const SnackBarThemeData(
            behavior: SnackBarBehavior.floating,
            width: 400,
          ),
        ),
        home: const NotificationOverlay(
          child: Home(),
        ),
      ),
    );
  }
}
