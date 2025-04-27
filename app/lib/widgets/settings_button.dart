import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';
import '../providers/team_provider.dart';

/// A widget that displays a settings button and shows a settings dialog when pressed
class SettingsButton extends StatelessWidget {
  /// Constructor
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings),
      tooltip: 'Settings',
      onPressed: () => _showSettingsDialog(context),
    );
  }

  /// Show the settings dialog
  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer2<SettingsProvider, TeamProvider>(
          builder: (context, settingsProvider, teamProvider, _) {
            return AlertDialog(
              title: const Text('Game Settings'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timer duration setting
                    const Text(
                      'Timer Duration (seconds):',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Slider(
                      value: settingsProvider.timerDuration.toDouble(),
                      min: 10,
                      max: 120,
                      divisions: 11,
                      label: settingsProvider.timerDuration.toString(),
                      onChanged: (double value) {
                        settingsProvider.setTimerDuration(value.toInt());
                      },
                    ),
                    Text('Current: ${settingsProvider.timerDuration} seconds'),
                    const SizedBox(height: 16),
                    
                    // Question count setting
                    const Text(
                      'Number of Questions per Game:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Slider(
                      value: settingsProvider.questionCount.toDouble(),
                      min: 5,
                      max: 30,
                      divisions: 5,
                      label: settingsProvider.questionCount.toString(),
                      onChanged: (double value) {
                        settingsProvider.setQuestionCount(value.toInt());
                      },
                    ),
                    Text('Current: ${settingsProvider.questionCount} questions'),
                    const SizedBox(height: 16),
                    
                    // Dark mode setting
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Dark Mode:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Switch(
                          value: settingsProvider.isDarkMode,
                          onChanged: (bool value) {
                            settingsProvider.setDarkMode(value);
                          },
                        ),
                      ],
                    ),
                    
                    // Sound effects setting
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sound Effects:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Switch(
                          value: settingsProvider.soundEffectsEnabled,
                          onChanged: (bool value) {
                            settingsProvider.setSoundEffects(value);
                          },
                        ),
                      ],
                    ),
                    
                    // Vibration setting
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Vibration:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Switch(
                          value: settingsProvider.vibrationEnabled,
                          onChanged: (bool value) {
                            settingsProvider.setVibrationEnabled(value);
                          },
                        ),
                      ],
                    ),
                    
                    const Divider(height: 32),
                    
                    // Team mode settings
                    const Text(
                      'Team Settings',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Team mode toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Enable Team Mode:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Switch(
                          value: teamProvider.teamModeEnabled,
                          onChanged: (bool value) {
                            teamProvider.setTeamModeEnabled(value);
                          },
                        ),
                      ],
                    ),
                    
                    // Team names (only shown when team mode is enabled)
                    if (teamProvider.teamModeEnabled) ...[
                      const SizedBox(height: 16),
                      
                      // Team 1 name
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Team 1 Name',
                          border: OutlineInputBorder(),
                        ),
                        controller: TextEditingController(text: teamProvider.team1Name),
                        onChanged: (value) {
                          teamProvider.setTeam1Name(value);
                        },
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Team 2 name
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Team 2 Name',
                          border: OutlineInputBorder(),
                        ),
                        controller: TextEditingController(text: teamProvider.team2Name),
                        onChanged: (value) {
                          teamProvider.setTeam2Name(value);
                        },
                      ),
                    ],
                  ],
                ),
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
      },
    );
  }
}
