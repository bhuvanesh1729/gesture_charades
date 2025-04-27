import 'package:json_annotation/json_annotation.dart';

part 'word.g.dart';

/// Categories for charades words
enum WordCategory {
  movies,
  actions,
  celebrities,
  animals,
  objects,
  sports,
  tvShows,
  books,
  custom
}

/// Difficulty levels for words
enum WordDifficulty {
  easy,
  medium,
  hard
}

/// Model representing a word or phrase for charades
@JsonSerializable()
class Word {
  /// The word or phrase to act out
  final String text;
  
  /// The category this word belongs to
  final WordCategory category;
  
  /// The difficulty level of this word
  final WordDifficulty difficulty;
  
  /// The language code (e.g., 'en', 'es', 'hi')
  final String languageCode;

  /// Constructor
  const Word({
    required this.text,
    required this.category,
    required this.difficulty,
    required this.languageCode,
  });

  /// Create from JSON
  factory Word.fromJson(Map<String, dynamic> json) => _$WordFromJson(json);
  
  /// Convert to JSON
  Map<String, dynamic> toJson() => _$WordToJson(this);
}
