class TranslationsRepository {
  final en = {'app_name': 'sample'};
  final fr = {'app_name': 'exemple'};
  final String currentLocale;

  TranslationsRepository({required this.currentLocale});

  String translate(String key) {
    return _internalTranslate(key) ?? '!$key!';
  }

  String? _internalTranslate(String key) {
    switch (currentLocale) {
      case 'fr':
        return fr[key];
      case 'en':
        return en[key];
      default:
        return en[key];
    }
  }
}
