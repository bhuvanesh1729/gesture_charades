import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/team_provider.dart';

/// A widget that displays team scores and controls
class TeamScoreDisplay extends StatelessWidget {
  /// Constructor
  const TeamScoreDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TeamProvider>(
      builder: (context, teamProvider, _) {
        // If team mode is not enabled, don't show anything
        if (!teamProvider.teamModeEnabled) {
          return const SizedBox.shrink();
        }
        
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // Team scores
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Team 1 score
                  _buildTeamScore(
                    context,
                    teamProvider.team1Name,
                    teamProvider.team1Score,
                    teamProvider.activeTeam == 1,
                  ),
                  
                  // VS divider
                  Text(
                    'VS',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  
                  // Team 2 score
                  _buildTeamScore(
                    context,
                    teamProvider.team2Name,
                    teamProvider.team2Score,
                    teamProvider.activeTeam == 2,
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Team controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Switch team button
                  ElevatedButton.icon(
                    onPressed: () {
                      teamProvider.switchActiveTeam();
                    },
                    icon: const Icon(Icons.swap_horiz),
                    label: const Text('Switch Team'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Reset scores button
                  ElevatedButton.icon(
                    onPressed: () {
                      _showResetConfirmationDialog(context, teamProvider);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset Scores'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      foregroundColor: Theme.of(context).colorScheme.onError,
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
  
  /// Build a team score display
  Widget _buildTeamScore(
    BuildContext context,
    String teamName,
    int score,
    bool isActive,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline,
          width: 2,
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
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Team score
          Text(
            score.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
          
          // Active indicator
          if (isActive) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Active',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ],
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
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                teamProvider.resetScores();
                Navigator.of(context).pop();
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }
}
