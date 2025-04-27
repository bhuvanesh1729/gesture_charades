import 'language_model.dart';

/// List of supported languages in the app
class SupportedLanguages {
  /// Private constructor to prevent instantiation
  SupportedLanguages._();
  
  /// English language
  static const LanguageModel english = LanguageModel(
    code: 'en',
    name: 'English',
    localeName: 'en_US',
    flagEmoji: '🇺🇸',
  );
  
  /// Spanish language
  static const LanguageModel spanish = LanguageModel(
    code: 'es',
    name: 'Español',
    localeName: 'es_ES',
    flagEmoji: '🇪🇸',
  );
  
  /// Hindi language
  static const LanguageModel hindi = LanguageModel(
    code: 'hi',
    name: 'हिन्दी',
    localeName: 'hi_IN',
    flagEmoji: '🇮🇳',
  );
  
  /// French language
  static const LanguageModel french = LanguageModel(
    code: 'fr',
    name: 'Français',
    localeName: 'fr_FR',
    flagEmoji: '🇫🇷',
  );
  
  /// German language
  static const LanguageModel german = LanguageModel(
    code: 'de',
    name: 'Deutsch',
    localeName: 'de_DE',
    flagEmoji: '🇩🇪',
  );
  
  /// List of all supported languages
  static const List<LanguageModel> allLanguages = [
    english,
    spanish,
    hindi,
    french,
    german,
  ];
  
  /// Get a language by its code
  static LanguageModel getByCode(String code) {
    return allLanguages.firstWhere(
      (lang) => lang.code == code,
      orElse: () => english, // Default to English if not found
    );
  }
}
