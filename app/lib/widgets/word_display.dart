import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:core_models/core_models.dart';

import '../providers/game_provider.dart';

/// A widget that displays the current word
class WordDisplay extends StatelessWidget {
  /// Constructor
  const WordDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, _) {
        // If the game is not active, show a message
        if (!gameProvider.isGameActive) {
          return const Text(
            'Press Start to Begin',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          );
        }
        
        // If there is no current word, show a loading message
        if (gameProvider.currentWord == null) {
          return const Text(
            'Loading...',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          );
        }
        
        // Show the current word
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display the word category
              Text(
                gameProvider.currentWord!.category.toString().split('.').last,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Display the word
              Text(
                gameProvider.currentWord!.text,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // Display the difficulty
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(gameProvider.currentWord!.difficulty),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  gameProvider.currentWord!.difficulty.toString().split('.').last,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Display an image based on the category
              Container(
                width: 200,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    _getCategoryIcon(gameProvider.currentWord!.category),
                    size: 80,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Display some hints or information
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hints:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getHintForWord(gameProvider.currentWord!),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  /// Get the color for the difficulty
  Color _getDifficultyColor(WordDifficulty difficulty) {
    switch (difficulty) {
      case WordDifficulty.easy:
        return Colors.green;
      case WordDifficulty.medium:
        return Colors.orange;
      case WordDifficulty.hard:
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
  
  /// Get an icon for the category
  IconData _getCategoryIcon(WordCategory category) {
    switch (category) {
      case WordCategory.movies:
        return Icons.movie;
      case WordCategory.actions:
        return Icons.sports_martial_arts;
      case WordCategory.celebrities:
        return Icons.person;
      case WordCategory.animals:
        return Icons.pets;
      case WordCategory.objects:
        return Icons.category;
      case WordCategory.sports:
        return Icons.sports_basketball;
      case WordCategory.tvShows:
        return Icons.tv;
      case WordCategory.books:
        return Icons.book;
      case WordCategory.custom:
        return Icons.star;
      default:
        return Icons.help_outline;
    }
  }
  
  /// Get a hint for the word
  String _getHintForWord(Word word) {
    switch (word.category) {
      case WordCategory.movies:
        return 'This is a movie title. Try using gestures to indicate watching a film or specific scenes from the movie.';
      case WordCategory.actions:
        return 'This is an action or activity. Focus on the movements and gestures associated with this action.';
      case WordCategory.celebrities:
        return 'This is a famous person. Try to mimic their distinctive traits, profession, or something they\'re known for.';
      case WordCategory.animals:
        return 'This is an animal. Mimic its movements, sounds (without making actual sounds), and characteristics.';
      case WordCategory.objects:
        return 'This is an object. Show its shape, size, and how it\'s typically used.';
      case WordCategory.sports:
        return 'This is related to sports. Demonstrate the movements, equipment, or rules associated with this sport.';
      case WordCategory.tvShows:
        return 'This is a TV show. Try to act out scenes or characters from the show.';
      case WordCategory.books:
        return 'This is a book title or related to literature. Try to convey the theme or story elements.';
      case WordCategory.custom:
        return 'This is a custom category. Use creative gestures to convey the meaning.';
      default:
        return 'Use expressive gestures to help your team guess this word!';
    }
  }
}
