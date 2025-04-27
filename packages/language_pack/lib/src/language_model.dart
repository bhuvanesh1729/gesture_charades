/// Model representing a supported language in the app
class LanguageModel {
  /// The language code (e.g., 'en', 'es', 'hi')
  final String code;
  
  /// The display name of the language (e.g., 'English', 'Español', 'हिन्दी')
  final String name;
  
  /// The locale name (e.g., 'en_US', 'es_ES', 'hi_IN')
  final String localeName;
  
  /// Flag emoji representing the language
  final String flagEmoji;

  /// Constructor
  const LanguageModel({
    required this.code,
    required this.name,
    required this.localeName,
    required this.flagEmoji,
  });
}
