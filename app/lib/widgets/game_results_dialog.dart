import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/team_provider.dart';

/// A dialog that shows game results and handles team transitions
class GameResultsDialog {
  /// Show the appropriate dialog based on the game state
  static void showDialog(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    
    // If team mode is enabled and team 1 just finished
    if (gameProvider.isTeamMode && gameProvider.isTeam1Finished && !gameProvider.isGameFinished) {
      _showTeam2StartDialog(context);
    }
    // If team mode is enabled and both teams have finished
    else if (gameProvider.isTeamMode && gameProvider.isGameFinished) {
      _showFinalResultsDialog(context);
    }
    // If not in team mode, show regular results
    else {
      _showRegularResultsDialog(context);
    }
  }
  
  /// Show a dialog to start team 2's turn
  static void _showTeam2StartDialog(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final teamProvider = Provider.of<TeamProvider>(context, listen: false);
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (context, animation, secondaryAnimation) {
        return AlertDialog(
          title: const Text('Team 1 Finished!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${teamProvider.team1Name} scored ${gameProvider.team1FinalScore} points!',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Now it\'s ${teamProvider.team2Name}\'s turn.',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  // Switch to team 2
                  teamProvider.switchActiveTeam();
                  
                  // Start the game for team 2
                  gameProvider.startGame(
                    settingsProvider.timerDuration,
                    questionCount: settingsProvider.questionCount,
                    isTeamMode: true,
                  );
                  
                  // Close the dialog
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.play_arrow),
                label: Text('Start ${teamProvider.team2Name}\'s Turn'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  /// Show the final results dialog
  static void _showFinalResultsDialog(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final teamProvider = Provider.of<TeamProvider>(context, listen: false);
    
    // Determine the winner
    String resultText;
    if (gameProvider.team1FinalScore > gameProvider.team2FinalScore) {
      resultText = '${teamProvider.team1Name} wins!';
    } else if (gameProvider.team2FinalScore > gameProvider.team1FinalScore) {
      resultText = '${teamProvider.team2Name} wins!';
    } else {
      resultText = 'It\'s a tie!';
    }
    
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (context, animation, secondaryAnimation) {
        return AlertDialog(
          title: const Text('Game Results'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                resultText,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Team 1 score
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      teamProvider.team1Name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${gameProvider.team1FinalScore} points',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Team 2 score
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      teamProvider.team2Name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${gameProvider.team2FinalScore} points',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                // Reset scores
                teamProvider.resetScores();
                
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('New Game'),
            ),
          ],
        );
      },
    );
  }
  
  /// Show regular results dialog
  static void _showRegularResultsDialog(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      pageBuilder: (context, animation, secondaryAnimation) {
        return AlertDialog(
          title: const Text('Game Results'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Game Over!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'You scored ${gameProvider.score} points!',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Questions answered: ${gameProvider.questionsAnswered}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
