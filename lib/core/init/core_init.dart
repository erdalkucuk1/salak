class CoreInit {
  static Future<void> init() async {
    // Core modül için gerekli başlangıç ayarları burada yapılacak
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
