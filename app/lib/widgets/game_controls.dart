import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/team_provider.dart';

/// A widget that provides controls for the game
class GameControls extends StatelessWidget {
  /// Constructor
  const GameControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, _) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Game controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Start/Stop button
                  ElevatedButton.icon(
                    onPressed: () {
                      if (gameProvider.isGameActive) {
                        gameProvider.endGame();
                      } else {
                        final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
                        final teamProvider = Provider.of<TeamProvider>(context, listen: false);
                        
                        // If team 1 has finished and we're in team mode, start team 2's turn
                        if (gameProvider.isTeamMode && gameProvider.isTeam1Finished && !gameProvider.isGameFinished) {
                          teamProvider.switchActiveTeam();
                          gameProvider.startGame(
                            settingsProvider.timerDuration,
                            questionCount: settingsProvider.questionCount,
                            isTeamMode: true,
                          );
                        } 
                        // Otherwise start a new game
                        else {
                          gameProvider.startGame(
                            settingsProvider.timerDuration,
                            questionCount: settingsProvider.questionCount,
                            isTeamMode: teamProvider.teamModeEnabled,
                          );
                        }
                      }
                    },
                    icon: Icon(
                      gameProvider.isGameActive ? Icons.stop : Icons.play_arrow,
                    ),
                    label: Text(
                      gameProvider.isGameActive 
                        ? 'Stop Game' 
                        : (gameProvider.isTeamMode && gameProvider.isTeam1Finished && !gameProvider.isGameFinished)
                          ? 'Start Team 2\'s Turn'
                          : 'Start Game',
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                  
                  // Correct button (only shown when game is active)
                  if (gameProvider.isGameActive) ...[
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        gameProvider.markCorrect();
                        
                        // Add points to the active team if team mode is enabled
                        final teamProvider = Provider.of<TeamProvider>(context, listen: false);
                        if (teamProvider.teamModeEnabled) {
                          teamProvider.addPointsToActiveTeam(1);
                        }
                        
                        // Reset the timer
                        final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
                        gameProvider.resetTimer(settingsProvider.timerDuration);
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Correct'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                ],
              ),
              
              // Game stats (only shown when game is not active)
              if (!gameProvider.isGameActive && gameProvider.score > 0) ...[
                const SizedBox(height: 16),
                Text(
                  'Last Game Score: ${gameProvider.score}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
