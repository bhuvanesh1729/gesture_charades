import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';

/// A widget that displays the timer
class TimerDisplay extends StatelessWidget {
  /// Constructor
  const TimerDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, _) {
        // If the game is not active, don't show the timer
        if (!gameProvider.isGameActive) {
          return const SizedBox.shrink();
        }
        
        // Calculate the progress
        final progress = gameProvider.remainingTime / 60.0;
        
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Display the score and question count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Score
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      const SizedBox(width: 8),
                      Text(
                        'Score: ${gameProvider.score}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  
                  // Question count
                  Row(
                    children: [
                      const Icon(Icons.question_answer, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        'Q: ${gameProvider.questionsAnswered}/${gameProvider.maxQuestions}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Display the timer
              Row(
                children: [
                  // Timer icon
                  const Icon(Icons.timer),
                  const SizedBox(width: 8),
                  // Timer progress bar
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getTimerColor(progress),
                        ),
                        minHeight: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Timer text
                  Text(
                    '${gameProvider.remainingTime}s',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  
  /// Get the color for the timer based on the progress
  Color _getTimerColor(double progress) {
    if (progress > 0.6) {
      return Colors.green;
    } else if (progress > 0.3) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
