import 'package:core_models/core_models.dart';

/// Provider for default word packs in different languages
class DefaultWordPacks {
  /// Private constructor to prevent instantiation
  DefaultWordPacks._();
  
  /// Get default word packs for a specific language
  static Map<WordCategory, List<Word>> getForLanguage(String languageCode) {
    switch (languageCode) {
      case 'en':
        return _englishWordPacks;
      case 'es':
        return _spanishWordPacks;
      case 'hi':
        return _hindiWordPacks;
      case 'fr':
        return _frenchWordPacks;
      case 'de':
        return _germanWordPacks;
      default:
        return _englishWordPacks; // Default to English
    }
  }
  
  /// English word packs
  static final Map<WordCategory, List<Word>> _englishWordPacks = {
    WordCategory.movies: [
      Word(text: 'Harry Potter', category: WordCategory.movies, difficulty: WordDifficulty.easy, languageCode: 'en'),
      Word(text: 'Star Wars', category: WordCategory.movies, difficulty: WordDifficulty.easy, languageCode: 'en'),
      Word(text: 'The Matrix', category: WordCategory.movies, difficulty: WordDifficulty.medium, languageCode: 'en'),
      Word(text: 'Titanic', category: WordCategory.movies, difficulty: WordDifficulty.easy, languageCode: 'en'),
      Word(text: 'Inception', category: WordCategory.movies, difficulty: WordDifficulty.hard, languageCode: 'en'),
    ],
    WordCategory.actions: [
      Word(text: 'Dancing', category: WordCategory.actions, difficulty: WordDifficulty.easy, languageCode: 'en'),
      Word(text: 'Swimming', category: WordCategory.actions, difficulty: WordDifficulty.easy, languageCode: 'en'),
      Word(text: 'Cooking', category: WordCategory.actions, difficulty: WordDifficulty.medium, languageCode: 'en'),
      Word(text: 'Skydiving', category: WordCategory.actions, difficulty: WordDifficulty.hard, languageCode: 'en'),
      Word(text: 'Typing', category: WordCategory.actions, difficulty: WordDifficulty.medium, languageCode: 'en'),
    ],
    WordCategory.celebrities: [
      Word(text: 'Superman', category: WordCategory.celebrities, difficulty: WordDifficulty.easy, languageCode: 'en'),
      Word(text: 'Michael Jackson', category: WordCategory.celebrities, difficulty: WordDifficulty.medium, languageCode: 'en'),
      Word(text: 'Albert Einstein', category: WordCategory.celebrities, difficulty: WordDifficulty.hard, languageCode: 'en'),
      Word(text: 'Beyoncé', category: WordCategory.celebrities, difficulty: WordDifficulty.medium, languageCode: 'en'),
      Word(text: 'Spider-Man', category: WordCategory.celebrities, difficulty: WordDifficulty.easy, languageCode: 'en'),
    ],
    WordCategory.animals: [
      Word(text: 'Elephant', category: WordCategory.animals, difficulty: WordDifficulty.easy, languageCode: 'en'),
      Word(text: 'Giraffe', category: WordCategory.animals, difficulty: WordDifficulty.medium, languageCode: 'en'),
      Word(text: 'Penguin', category: WordCategory.animals, difficulty: WordDifficulty.medium, languageCode: 'en'),
      Word(text: 'Kangaroo', category: WordCategory.animals, difficulty: WordDifficulty.medium, languageCode: 'en'),
      Word(text: 'Octopus', category: WordCategory.animals, difficulty: WordDifficulty.hard, languageCode: 'en'),
    ],
    WordCategory.objects: [
      Word(text: 'Smartphone', category: WordCategory.objects, difficulty: WordDifficulty.easy, languageCode: 'en'),
      Word(text: 'Umbrella', category: WordCategory.objects, difficulty: WordDifficulty.medium, languageCode: 'en'),
      Word(text: 'Guitar', category: WordCategory.objects, difficulty: WordDifficulty.medium, languageCode: 'en'),
      Word(text: 'Refrigerator', category: WordCategory.objects, difficulty: WordDifficulty.hard, languageCode: 'en'),
      Word(text: 'Helicopter', category: WordCategory.objects, difficulty: WordDifficulty.hard, languageCode: 'en'),
    ],
  };
  
  /// Spanish word packs
  static final Map<WordCategory, List<Word>> _spanishWordPacks = {
    WordCategory.movies: [
      Word(text: 'Harry Potter', category: WordCategory.movies, difficulty: WordDifficulty.easy, languageCode: 'es'),
      Word(text: 'La Guerra de las Galaxias', category: WordCategory.movies, difficulty: WordDifficulty.easy, languageCode: 'es'),
      Word(text: 'Matrix', category: WordCategory.movies, difficulty: WordDifficulty.medium, languageCode: 'es'),
      Word(text: 'Titanic', category: WordCategory.movies, difficulty: WordDifficulty.easy, languageCode: 'es'),
      Word(text: 'Origen', category: WordCategory.movies, difficulty: WordDifficulty.hard, languageCode: 'es'),
    ],
    WordCategory.actions: [
      Word(text: 'Bailar', category: WordCategory.actions, difficulty: WordDifficulty.easy, languageCode: 'es'),
      Word(text: 'Nadar', category: WordCategory.actions, difficulty: WordDifficulty.easy, languageCode: 'es'),
      Word(text: 'Cocinar', category: WordCategory.actions, difficulty: WordDifficulty.medium, languageCode: 'es'),
      Word(text: 'Paracaidismo', category: WordCategory.actions, difficulty: WordDifficulty.hard, languageCode: 'es'),
      Word(text: 'Escribir', category: WordCategory.actions, difficulty: WordDifficulty.medium, languageCode: 'es'),
    ],
    // Add more Spanish categories as needed
  };
  
  /// Hindi word packs
  static final Map<WordCategory, List<Word>> _hindiWordPacks = {
    WordCategory.movies: [
      Word(text: 'हैरी पॉटर', category: WordCategory.movies, difficulty: WordDifficulty.easy, languageCode: 'hi'),
      Word(text: 'स्टार वॉर्स', category: WordCategory.movies, difficulty: WordDifficulty.easy, languageCode: 'hi'),
      Word(text: 'मैट्रिक्स', category: WordCategory.movies, difficulty: WordDifficulty.medium, languageCode: 'hi'),
      Word(text: 'टाइटैनिक', category: WordCategory.movies, difficulty: WordDifficulty.easy, languageCode: 'hi'),
      Word(text: 'इन्सेप्शन', category: WordCategory.movies, difficulty: WordDifficulty.hard, languageCode: 'hi'),
    ],
    WordCategory.actions: [
      Word(text: 'नाचना', category: WordCategory.actions, difficulty: WordDifficulty.easy, languageCode: 'hi'),
      Word(text: 'तैरना', category: WordCategory.actions, difficulty: WordDifficulty.easy, languageCode: 'hi'),
      Word(text: 'खाना बनाना', category: WordCategory.actions, difficulty: WordDifficulty.medium, languageCode: 'hi'),
      Word(text: 'स्काईडाइविंग', category: WordCategory.actions, difficulty: WordDifficulty.hard, languageCode: 'hi'),
      Word(text: 'टाइपिंग', category: WordCategory.actions, difficulty: WordDifficulty.medium, languageCode: 'hi'),
    ],
    // Add more Hindi categories as needed
  };
  
  /// French word packs
  static final Map<WordCategory, List<Word>> _frenchWordPacks = {
    WordCategory.movies: [
      Word(text: 'Harry Potter', category: WordCategory.movies, difficulty: WordDifficulty.easy, languageCode: 'fr'),
      Word(text: 'La Guerre des Étoiles', category: WordCategory.movies, difficulty: WordDifficulty.easy, languageCode: 'fr'),
      Word(text: 'Matrix', category: WordCategory.movies, difficulty: WordDifficulty.medium, languageCode: 'fr'),
      Word(text: 'Titanic', category: WordCategory.movies, difficulty: WordDifficulty.easy, languageCode: 'fr'),
      Word(text: 'Inception', category: WordCategory.movies, difficulty: WordDifficulty.hard, languageCode: 'fr'),
    ],
    // Add more French categories as needed
  };
  
  /// German word packs
  static final Map<WordCategory, List<Word>> _germanWordPacks = {
    WordCategory.movies: [
      Word(text: 'Harry Potter', category: WordCategory.movies, difficulty: WordDifficulty.easy, languageCode: 'de'),
      Word(text: 'Krieg der Sterne', category: WordCategory.movies, difficulty: WordDifficulty.easy, languageCode: 'de'),
      Word(text: 'Matrix', category: WordCategory.movies, difficulty: WordDifficulty.medium, languageCode: 'de'),
      Word(text: 'Titanic', category: WordCategory.movies, difficulty: WordDifficulty.easy, languageCode: 'de'),
      Word(text: 'Inception', category: WordCategory.movies, difficulty: WordDifficulty.hard, languageCode: 'de'),
    ],
    // Add more German categories as needed
  };
}
