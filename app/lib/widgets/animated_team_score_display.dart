import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/team_provider.dart';

/// An animated widget that displays team scores and controls
class AnimatedTeamScoreDisplay extends StatefulWidget {
  /// Constructor
  const AnimatedTeamScoreDisplay({super.key});

  @override
  State<AnimatedTeamScoreDisplay> createState() => _AnimatedTeamScoreDisplayState();
}

class _AnimatedTeamScoreDisplayState extends State<AnimatedTeamScoreDisplay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  
  int? _previousTeam1Score;
  int? _previousTeam2Score;
  int? _activeTeam;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
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
    return Consumer<TeamProvider>(
      builder: (context, teamProvider, _) {
        // If team mode is not enabled, don't show anything
        if (!teamProvider.teamModeEnabled) {
          return const SizedBox.shrink();
        }
        
        // Check if scores have changed
        if (_previousTeam1Score != teamProvider.team1Score || 
            _previousTeam2Score != teamProvider.team2Score ||
            _activeTeam != teamProvider.activeTeam) {
          
          // If team 1 score changed
          if (_previousTeam1Score != null && 
              _previousTeam1Score != teamProvider.team1Score) {
            if (teamProvider.activeTeam == 1) {
              _controller.reset();
              _controller.forward();
            }
          }
          
          // If team 2 score changed
          if (_previousTeam2Score != null && 
              _previousTeam2Score != teamProvider.team2Score) {
            if (teamProvider.activeTeam == 2) {
              _controller.reset();
              _controller.forward();
            }
          }
          
          // Update previous values
          _previousTeam1Score = teamProvider.team1Score;
          _previousTeam2Score = teamProvider.team2Score;
          _activeTeam = teamProvider.activeTeam;
        }
        
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.7),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Team scores
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Team 1 score
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: teamProvider.activeTeam == 1 && _controller.isAnimating
                            ? _scaleAnimation.value
                            : 1.0,
                        child: child,
                      );
                    },
                    child: _buildTeamScore(
                      context,
                      teamProvider.team1Name,
                      teamProvider.team1Score,
                      teamProvider.activeTeam == 1,
                      teamColor: Colors.blue,
                    ),
                  ),
                  
                  // VS divider
                  Container(
                    width: 2,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  
                  // Team 2 score
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: teamProvider.activeTeam == 2 && _controller.isAnimating
                            ? _scaleAnimation.value
                            : 1.0,
                        child: child,
                      );
                    },
                    child: _buildTeamScore(
                      context,
                      teamProvider.team2Name,
                      teamProvider.team2Score,
                      teamProvider.activeTeam == 2,
                      teamColor: Colors.red,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Team controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Switch team button
                  _buildControlButton(
                    context,
                    icon: Icons.swap_horiz,
                    label: 'Switch Team',
                    color: Theme.of(context).colorScheme.secondary,
                    onPressed: () {
                      teamProvider.switchActiveTeam();
                    },
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Reset scores button
                  _buildControlButton(
                    context,
                    icon: Icons.refresh,
                    label: 'Reset Scores',
                    color: Theme.of(context).colorScheme.error,
                    onPressed: () {
                      _showResetConfirmationDialog(context, teamProvider);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  
  /// Build a team score display
  Widget _buildTeamScore(
    BuildContext context,
    String teamName,
    int score,
    bool isActive,
    {required Color teamColor}
  ) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isActive
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  teamColor.withOpacity(0.7),
                  teamColor.withOpacity(0.4),
                ],
              )
            : null,
        color: isActive ? null : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isActive
                ? teamColor.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
            blurRadius: isActive ? 8 : 4,
            spreadRadius: isActive ? 1 : 0,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isActive
              ? teamColor
              : Theme.of(context).colorScheme.outline.withOpacity(0.5),
          width: isActive ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          // Team name
          Text(
            teamName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isActive
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          // Team score
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.white.withOpacity(0.2)
                  : Theme.of(context).colorScheme.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: Text(
              score.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isActive
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          
          // Active indicator
          if (isActive) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.play_arrow,
                    size: 12,
                    color: teamColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Active',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: teamColor,
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
  
  /// Build a control button
  Widget _buildControlButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
    );
  }
  
  /// Show a confirmation dialog for resetting scores
  void _showResetConfirmationDialog(
    BuildContext context,
    TeamProvider teamProvider,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Scores'),
          content: const Text(
            'Are you sure you want to reset both team scores to zero?',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                teamProvider.resetScores();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }
}
