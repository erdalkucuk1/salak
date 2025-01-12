import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/app_constants.dart';
import 'extensions/context_extension.dart';
import 'widgets/base_page.dart';
import 'widgets/custom_button.dart';
import 'widgets/loading_overlay.dart';
import 'widgets/responsive_builder.dart';
import 'utils/screen_utils.dart';
import 'providers/form_provider.dart';
import 'providers/notification_provider.dart';
import 'pages/error_history_page.dart';
import 'providers/theme_provider.dart';
import 'error/error_handler.dart';
import 'error/failures.dart';
import 'providers/language_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> _onSubmit() async {
    final success = await context.read<FormProvider>().submitForm();
    if (!mounted) return;

    if (success) {
      context.read<NotificationProvider>().showSuccess(
        AppConstants.getText(context, 'core.form.success'),
        action: () {
          if (!mounted) return;
          debugPrint('Bildirime tıklandı');
        },
        actionLabel: AppConstants.getText(context, 'core.buttons.details'),
      );
    } else {
      final error = context.read<FormProvider>().lastError;
      if (error != null) {
        context.read<NotificationProvider>().showError(
              error.message,
              duration: const Duration(seconds: 6),
            );
      }
    }
  }

  Widget _buildContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppConstants.getText(context, 'homePageTitle'),
            style: context.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.height * 0.04),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                SizedBox(
                  width: 220,
                  child: CustomButton(
                    text: AppConstants.getText(context, 'errorTest'),
                    onPressed: _onSubmit,
                  ),
                ),
                SizedBox(
                  width: 220,
                  child: CustomButton(
                    text: AppConstants.getText(context, 'aiAnalysis'),
                    onPressed: () {
                      if (context.mounted) {
                        ErrorHandler.analyzeError(
                          context,
                          UnexpectedFailure(
                              message: 'Kod analizi ve optimizasyon önerileri',
                              source: 'Home._buildContent',
                              code: 'CODE_ANALYSIS_REQUEST',
                              errorType: 'CODE_ANALYSIS',
                              additionalData: <String, dynamic>{
                                'Analiz Tipi': 'Kod Kalitesi',
                                'Modül': 'Core',
                                'İnceleme Alanları': {
                                  'Performans': [
                                    'Widget rebuild optimizasyonu',
                                    'Gereksiz build işlemleri',
                                    'Bellek kullanımı'
                                  ],
                                  'Güvenlik': [
                                    'Veri validasyonu',
                                    'Hata yakalama mekanizmaları',
                                    'Güvenli state yönetimi'
                                  ],
                                  'Best Practices': [
                                    'Kod organizasyonu',
                                    'SOLID prensipleri',
                                    'Widget modülerliği'
                                  ],
                                  'Error Handling': [
                                    'Hata loglama',
                                    'Kullanıcı bildirimleri',
                                    'Hata kurtarma mekanizmaları'
                                  ]
                                },
                                'Öncelik': 'Yüksek'
                              }),
                        );
                      }
                    },
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: context.height * 0.04),
          Text(
            'Cihaz Tipi: ${ScreenUtils.isDesktop(context) ? 'Desktop' : ScreenUtils.isTablet(context) ? 'Tablet' : 'Telefon'}',
            style: context.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FormProvider>(
      builder: (context, provider, child) => LoadingOverlay(
        isLoading: provider.isLoading,
        loadingText: AppConstants.getText(context, 'core.loading.text'),
        child: BasePage(
          title: AppConstants.getText(context, 'core.app.name'),
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          actions: [
            Consumer<LanguageProvider>(
              builder: (context, languageProvider, _) => IconButton(
                icon: Text(
                  languageProvider.currentLanguage == AppLanguage.tr
                      ? 'EN'
                      : 'TR',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                onPressed: () => languageProvider.toggleLanguage(),
                tooltip: languageProvider.currentLanguage == AppLanguage.tr
                    ? 'Switch to English'
                    : 'Türkçe\'ye geç',
              ),
            ),
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, _) => IconButton(
                icon: Icon(
                  themeProvider.isDark ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () => themeProvider.toggleTheme(),
                tooltip: themeProvider.isDark ? 'Açık Tema' : 'Koyu Tema',
              ),
            ),
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ErrorHistoryPage(),
                  ),
                );
              },
              tooltip: 'Hata Geçmişi',
            ),
          ],
          body: ResponsiveBuilder(
            mobile: _buildContent(),
            tablet: Center(
              child: SizedBox(
                width: ScreenUtils.getResponsiveWidth(context, 0.6),
                child: _buildContent(),
              ),
            ),
            desktop: Center(
              child: SizedBox(
                width: ScreenUtils.getResponsiveWidth(context, 0.4),
                child: _buildContent(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
