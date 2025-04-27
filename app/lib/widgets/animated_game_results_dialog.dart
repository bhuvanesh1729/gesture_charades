import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

import '../providers/game_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/team_provider.dart';

/// A dialog that shows game results with animations and enhanced visuals
class AnimatedGameResultsDialog {
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
      barrierLabel: 'Team 2 Start Dialog',
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.5, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.elasticOut,
              ),
            ),
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 8,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue.shade100,
                  Colors.blue.shade50,
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Team 1 finished banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Team 1 Finished!',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Team 1 score
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.2),
                        blurRadius: 8,
                        spreadRadius: 1,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        teamProvider.team1Name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
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
                            '${gameProvider.team1FinalScore}',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'points',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Team 2 turn message
                Text(
                  'Now it\'s ${teamProvider.team2Name}\'s turn.',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 24),
                
                // Start team 2 button
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
                  label: Text(
                    'Start ${teamProvider.team2Name}\'s Turn',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                ),
              ],
            ),
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
    Color winnerColor;
    bool isTie = false;
    
    if (gameProvider.team1FinalScore > gameProvider.team2FinalScore) {
      resultText = '${teamProvider.team1Name} wins!';
      winnerColor = Colors.blue;
    } else if (gameProvider.team2FinalScore > gameProvider.team1FinalScore) {
      resultText = '${teamProvider.team2Name} wins!';
      winnerColor = Colors.red;
    } else {
      resultText = 'It\'s a tie!';
      winnerColor = Colors.purple;
      isTie = true;
    }
    
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Final Results Dialog',
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.5, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.elasticOut,
              ),
            ),
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return _ConfettiDialog(
          title: 'Game Results',
          winnerColor: winnerColor,
          showConfetti: !isTie,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Winner banner
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      winnerColor,
                      winnerColor.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: winnerColor.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  resultText,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Team scores
              Row(
                children: [
                  // Team 1 score
                  Expanded(
                    child: _buildTeamScoreCard(
                      context,
                      teamName: teamProvider.team1Name,
                      score: gameProvider.team1FinalScore,
                      isWinner: gameProvider.team1FinalScore > gameProvider.team2FinalScore,
                      teamColor: Colors.blue,
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Team 2 score
                  Expanded(
                    child: _buildTeamScoreCard(
                      context,
                      teamName: teamProvider.team2Name,
                      score: gameProvider.team2FinalScore,
                      isWinner: gameProvider.team2FinalScore > gameProvider.team1FinalScore,
                      teamColor: Colors.red,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Close button
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                    label: const Text('Close'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  
                  // New game button
                  ElevatedButton.icon(
                    onPressed: () {
                      // Reset scores
                      teamProvider.resetScores();
                      
                      // Close the dialog
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.replay),
                    label: const Text('New Game'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
  
  /// Show regular results dialog
  static void _showRegularResultsDialog(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Game Results Dialog',
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.5, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.elasticOut,
              ),
            ),
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return _ConfettiDialog(
          title: 'Game Results',
          winnerColor: Colors.blue,
          showConfetti: gameProvider.score > 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Game over banner
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue,
                      Colors.blue.shade700,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  'Game Over!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Score display
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Your Score',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'points',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Questions answered
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blue.shade200,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.question_answer,
                      color: Colors.blue.shade700,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Questions answered: ${gameProvider.questionsAnswered}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Close button
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.check_circle),
                label: const Text('Close'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  /// Build a team score card
  static Widget _buildTeamScoreCard(
    BuildContext context, {
    required String teamName,
    required int score,
    required bool isWinner,
    required Color teamColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isWinner ? teamColor.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isWinner ? teamColor : Colors.grey.shade300,
          width: isWinner ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isWinner
                ? teamColor.withOpacity(0.2)
                : Colors.black.withOpacity(0.05),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Team name
          Text(
            teamName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: teamColor,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          // Team score
          Text(
            '$score',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: teamColor,
            ),
          ),
          
          // Winner badge
          if (isWinner) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: teamColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.emoji_events,
                    size: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Winner',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A dialog with confetti animation
class _ConfettiDialog extends StatefulWidget {
  /// The title of the dialog
  final String title;
  
  /// The color of the winner
  final Color winnerColor;
  
  /// Whether to show confetti
  final bool showConfetti;
  
  /// The child widget
  final Widget child;

  /// Constructor
  const _ConfettiDialog({
    required this.title,
    required this.winnerColor,
    required this.showConfetti,
    required this.child,
  });

  @override
  State<_ConfettiDialog> createState() => _ConfettiDialogState();
}

class _ConfettiDialogState extends State<_ConfettiDialog> {
  late ConfettiController _confettiController;
  
  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    
    if (widget.showConfetti) {
      _confettiController.play();
    }
  }
  
  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 8,
      child: Stack(
        children: [
          // Dialog content
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey.shade100,
                  Colors.white,
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: widget.winnerColor,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Child content
                widget.child,
              ],
            ),
          ),
          
          // Confetti
          if (widget.showConfetti) ...[
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: pi / 2,
                maxBlastForce: 5,
                minBlastForce: 1,
                emissionFrequency: 0.05,
                numberOfParticles: 20,
                gravity: 0.1,
                colors: [
                  Colors.red,
                  Colors.blue,
                  Colors.green,
                  Colors.yellow,
                  Colors.purple,
                  Colors.orange,
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
