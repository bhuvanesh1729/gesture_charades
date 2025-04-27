import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:sensors/sensors.dart';

import '../providers/game_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/team_provider.dart';
import '../screens/language_selection_screen.dart';
import '../widgets/category_selector.dart';
import '../widgets/animated_game_controls.dart';
import '../widgets/animated_game_results_dialog.dart';
import '../widgets/language_selector.dart';
import '../widgets/settings_button.dart';
import '../widgets/swipe_detector.dart';
import '../widgets/animated_background.dart';
import '../widgets/animated_team_score_display.dart';
import '../widgets/animated_timer_display.dart';
import '../widgets/animated_word_display.dart';
import '../widgets/social_share_widget.dart';

/// The main screen of the app
class HomeScreen extends StatefulWidget {
  /// Constructor
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Whether the phone is being flipped
  bool _isFlipping = false;
  
  /// Previous game active state
  bool _wasGameActive = false;
  
  @override
  void initState() {
    super.initState();
    _setupSensors();
    
    // Add a post-frame callback to set up the game provider listener
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupGameProviderListener();
    });
  }
  
  /// Set up a listener for the game provider to show results when the game ends
  void _setupGameProviderListener() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    
    // Listen for changes in the game provider
    gameProvider.addListener(() {
      // If the game was active but is now inactive, show the results dialog
      if (_wasGameActive && !gameProvider.isGameActive) {
        // Show the results dialog
        AnimatedGameResultsDialog.showDialog(context);
      }
      
      // Update the previous game active state
      _wasGameActive = gameProvider.isGameActive;
    });
  }
  
  /// Set up the accelerometer sensor for phone flip detection
  void _setupSensors() {
    // Skip sensor setup on web platform
    if (kIsWeb) return;
    
    accelerometerEvents.listen((AccelerometerEvent event) {
      // Detect a significant upward movement (negative z-axis)
      if (event.z < -12 && !_isFlipping) {
        _isFlipping = true;
        
        // Get the game provider
        final gameProvider = Provider.of<GameProvider>(context, listen: false);
        
        // If the game is active, move to the next word
        if (gameProvider.isGameActive) {
          gameProvider.nextWord();
          
          // Reset the timer
          final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
          gameProvider.resetTimer(settingsProvider.timerDuration);
        }
        
        // Reset the flipping state after a delay
        Future.delayed(const Duration(seconds: 1), () {
          _isFlipping = false;
        });
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Gesture Charades'),
        backgroundColor: theme.colorScheme.primary.withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.language),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LanguageSelectionScreen(),
              ),
            );
          },
          tooltip: 'Change Language',
        ),
        actions: const [
          LanguageSelector(),
          SettingsButton(),
        ],
      ),
      body: AnimatedBackground(
        particleCount: 40,
        gridColor: theme.colorScheme.onBackground.withOpacity(0.05),
        particleColor: theme.colorScheme.primary.withOpacity(0.3),
        gridSize: 30,
        child: SwipeDetector(
          onSwipeUp: () {
            // Get the game provider
            final gameProvider = Provider.of<GameProvider>(context, listen: false);
            
            // If the game is active, move to the next word
            if (gameProvider.isGameActive) {
              gameProvider.nextWord();
              
              // Reset the timer
              final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
              gameProvider.resetTimer(settingsProvider.timerDuration);
            }
          },
          onSwipeRight: () {
            // Get the game provider
            final gameProvider = Provider.of<GameProvider>(context, listen: false);
            
            // If the game is active, mark the current word as correct
            if (gameProvider.isGameActive) {
              gameProvider.markCorrect();
              
              // Add points to the active team if team mode is enabled
              final teamProvider = Provider.of<TeamProvider>(context, listen: false);
              if (teamProvider.teamModeEnabled) {
                teamProvider.addPointsToActiveTeam(1);
              }
              
              // Reset the timer
              final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
              gameProvider.resetTimer(settingsProvider.timerDuration);
            }
          },
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Timer display
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: AnimatedTimerDisplay(),
                  ),
                  
                  // Team score display
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: AnimatedTeamScoreDisplay(),
                  ),
                  
                  // Word display
                  SizedBox(
                    height: 300,
                    child: Center(
                      child: GlowingContainer(
                        glowColor: theme.colorScheme.primary,
                        child: const AnimatedWordDisplay(),
                      ),
                    ),
                  ),
                  
                  // Category selector
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CategorySelector(),
                      ),
                    ),
                  ),
                  
                  // Game controls
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: AnimatedGameControls(),
                  ),
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
