import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/team_provider.dart';

/// An animated widget that provides controls for the game
class AnimatedGameControls extends StatefulWidget {
  /// Constructor
  const AnimatedGameControls({super.key});

  @override
  State<AnimatedGameControls> createState() => _AnimatedGameControlsState();
}

class _AnimatedGameControlsState extends State<AnimatedGameControls> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
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
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Game controls
              if (!gameProvider.isGameActive) ...[
                // Start button (only shown when game is not active)
                _buildAnimatedButton(
                  onPressed: () {
                    _controller.forward().then((_) => _controller.reverse());
                    
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
                  },
                  icon: Icons.play_arrow,
                  label: (gameProvider.isTeamMode && gameProvider.isTeam1Finished && !gameProvider.isGameFinished)
                    ? 'Start Team 2\'s Turn'
                    : 'Start Game',
                  color: Theme.of(context).colorScheme.primary,
                  textColor: Theme.of(context).colorScheme.onPrimary,
                ),
              ] else ...[
                // Game action buttons (only shown when game is active)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildAnimatedButton(
                        onPressed: () {
                          _controller.forward().then((_) => _controller.reverse());
                          
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
                        icon: Icons.check,
                        label: 'Correct',
                        color: Colors.green,
                        textColor: Colors.white,
                      ),
                      
                      const SizedBox(width: 16),
                      _buildAnimatedButton(
                        onPressed: () {
                          _controller.forward().then((_) => _controller.reverse());
                          
                          gameProvider.nextWord();
                          
                          // Reset the timer
                          final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
                          gameProvider.resetTimer(settingsProvider.timerDuration);
                        },
                        icon: Icons.skip_next,
                        label: 'Skip',
                        color: Colors.orange,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Stop button at the bottom
                _buildAnimatedButton(
                  onPressed: () {
                    _controller.forward().then((_) => _controller.reverse());
                    gameProvider.endGame();
                  },
                  icon: Icons.stop,
                  label: 'Stop Game',
                  color: Theme.of(context).colorScheme.error,
                  textColor: Theme.of(context).colorScheme.onError,
                ),
              ],
              
              // Game stats (only shown when game is not active)
              if (!gameProvider.isGameActive && gameProvider.score > 0) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Last Game Score',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.emoji_events,
                            size: 32,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${gameProvider.score}',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'points',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
  
  /// Build an animated button
  Widget _buildAnimatedButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
    required Color textColor,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          shadowColor: color.withOpacity(0.4),
        ),
      ),
    );
  }
}
