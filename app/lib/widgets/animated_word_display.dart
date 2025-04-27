import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:core_models/core_models.dart';
import 'dart:math' as math;

import '../providers/game_provider.dart';

/// An animated widget that displays the current word with visual effects
class AnimatedWordDisplay extends StatefulWidget {
  /// Constructor
  const AnimatedWordDisplay({super.key});

  @override
  State<AnimatedWordDisplay> createState() => _AnimatedWordDisplayState();
}

class _AnimatedWordDisplayState extends State<AnimatedWordDisplay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  
  String? _previousWord;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );
    
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, _) {
        // Check if the word has changed
        if (gameProvider.currentWord != null && 
            gameProvider.currentWord!.text != _previousWord) {
          _previousWord = gameProvider.currentWord?.text;
          _controller.reset();
          _controller.forward();
        }
        
        // If the game is not active, show a message
        if (!gameProvider.isGameActive) {
          return _buildStartGamePrompt(context);
        }
        
        // If there is no current word, show a loading message
        if (gameProvider.currentWord == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        // Show the current word with animations
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
            );
          },
          child: _buildWordCard(context, gameProvider),
        );
      },
    );
  }
  
  /// Build the start game prompt
  Widget _buildStartGamePrompt(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.secondaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.play_circle_outline,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Press Start to Begin',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Get ready to act out words and phrases!',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build the word card
  Widget _buildWordCard(BuildContext context, GameProvider gameProvider) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          // Category badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: _getCategoryColor(gameProvider.currentWord!.category).withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getCategoryIcon(gameProvider.currentWord!.category),
                  size: 18,
                  color: _getCategoryColor(gameProvider.currentWord!.category),
                ),
                const SizedBox(width: 8),
                Text(
                  gameProvider.currentWord!.category.toString().split('.').last,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _getCategoryColor(gameProvider.currentWord!.category),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Word text with shimmer effect
          ShimmerText(
            text: gameProvider.currentWord!.text,
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Difficulty indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Difficulty: ',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 4),
              _buildDifficultyIndicator(context, gameProvider.currentWord!.difficulty),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Hint card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 20,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Hint',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _getHintForWord(gameProvider.currentWord!),
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Swipe instructions
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSwipeInstruction(
                context, 
                Icons.swipe_up, 
                'Swipe up to skip',
                Colors.orange,
              ),
              const SizedBox(width: 24),
              _buildSwipeInstruction(
                context, 
                Icons.swipe_right, 
                'Swipe right for correct',
                Colors.green,
              ),
            ],
          ),
          ],
        ),
      ),
    );
  }
  
  /// Build a difficulty indicator
  Widget _buildDifficultyIndicator(BuildContext context, WordDifficulty difficulty) {
    final color = _getDifficultyColor(difficulty);
    final label = difficulty.toString().split('.').last;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...List.generate(
            _getDifficultyLevel(difficulty),
            (index) => Padding(
              padding: const EdgeInsets.only(right: 2),
              child: Icon(
                Icons.star,
                size: 14,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Build a swipe instruction
  Widget _buildSwipeInstruction(
    BuildContext context,
    IconData icon,
    String text,
    Color color,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
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
  
  /// Get the difficulty level (1-3)
  int _getDifficultyLevel(WordDifficulty difficulty) {
    switch (difficulty) {
      case WordDifficulty.easy:
        return 1;
      case WordDifficulty.medium:
        return 2;
      case WordDifficulty.hard:
        return 3;
      default:
        return 1;
    }
  }
  
  /// Get the color for the category
  Color _getCategoryColor(WordCategory category) {
    switch (category) {
      case WordCategory.movies:
        return Colors.red;
      case WordCategory.actions:
        return Colors.orange;
      case WordCategory.celebrities:
        return Colors.purple;
      case WordCategory.animals:
        return Colors.green;
      case WordCategory.objects:
        return Colors.blue;
      case WordCategory.sports:
        return Colors.teal;
      case WordCategory.tvShows:
        return Colors.indigo;
      case WordCategory.books:
        return Colors.brown;
      case WordCategory.custom:
        return Colors.pink;
      default:
        return Colors.grey;
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

/// A widget that displays text with a shimmer effect
class ShimmerText extends StatefulWidget {
  /// The text to display
  final String text;
  
  /// The text style
  final TextStyle style;

  /// Constructor
  const ShimmerText({
    super.key,
    required this.text,
    required this.style,
  });

  @override
  State<ShimmerText> createState() => _ShimmerTextState();
}

class _ShimmerTextState extends State<ShimmerText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.5),
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withOpacity(0.5),
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              transform: GradientRotation(_animation.value * 2 * math.pi),
            ).createShader(bounds);
          },
          child: Text(
            widget.text,
            style: widget.style.copyWith(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
