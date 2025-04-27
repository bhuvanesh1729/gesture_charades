import 'dart:math';

import 'package:core_models/core_models.dart';

import 'default_word_packs.dart';

/// Provider for word packs in different languages
class WordPackProvider {
  /// The language code for this provider
  final String languageCode;
  
  /// Map of word categories to lists of words
  final Map<WordCategory, List<Word>> _wordsByCategory = {};
  
  /// Constructor
  WordPackProvider(this.languageCode) {
    _initializeWordPacks();
  }
  
  /// Initialize word packs for the current language
  void _initializeWordPacks() {
    // Load default word packs for the language
    final defaultPacks = DefaultWordPacks.getForLanguage(languageCode);
    
    // Initialize categories with default words
    for (final category in WordCategory.values) {
      _wordsByCategory[category] = defaultPacks[category] ?? [];
    }
  }
  
  /// Get all words for a specific category
  List<Word> getWordsForCategory(WordCategory category) {
    return List.unmodifiable(_wordsByCategory[category] ?? []);
  }
  
  /// Get all words across all categories
  List<Word> getAllWords() {
    final allWords = <Word>[];
    for (final words in _wordsByCategory.values) {
      allWords.addAll(words);
    }
    return List.unmodifiable(allWords);
  }
  
  /// Add a new word to a category
  void addWord(Word word) {
    if (word.languageCode != languageCode) {
      throw ArgumentError('Word language code does not match provider language code');
    }
    
    final categoryWords = _wordsByCategory[word.category] ?? [];
    if (!categoryWords.any((w) => w.text == word.text)) {
      categoryWords.add(word);
      _wordsByCategory[word.category] = categoryWords;
    }
  }
  
  /// Remove a word from a category
  void removeWord(Word word) {
    final categoryWords = _wordsByCategory[word.category] ?? [];
    categoryWords.removeWhere((w) => w.text == word.text);
    _wordsByCategory[word.category] = categoryWords;
  }
  
  /// Get a random word from a specific category
  Word? getRandomWordFromCategory(WordCategory category) {
    final words = _wordsByCategory[category] ?? [];
    if (words.isEmpty) return null;
    
    final random = Random();
    final index = random.nextInt(words.length);
    return words[index];
  }
  
  /// Get a random word from any category
  Word? getRandomWord() {
    final allWords = getAllWords();
    if (allWords.isEmpty) return null;
    
    final random = Random();
    final index = random.nextInt(allWords.length);
    return allWords[index];
  }
}
