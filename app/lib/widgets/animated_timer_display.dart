import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../providers/game_provider.dart';

/// An animated widget that displays the timer with visual effects
class AnimatedTimerDisplay extends StatefulWidget {
  /// Constructor
  const AnimatedTimerDisplay({super.key});

  @override
  State<AnimatedTimerDisplay> createState() => _AnimatedTimerDisplayState();
}

class _AnimatedTimerDisplayState extends State<AnimatedTimerDisplay> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  int? _previousTime;
  bool _isLowTime = false;
  
  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
    
    _pulseController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _pulseController.reverse();
      } else if (status == AnimationStatus.dismissed && _isLowTime) {
        _pulseController.forward();
      }
    });
  }
  
  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, _) {
        // If the game is not active, don't show the timer
        if (!gameProvider.isGameActive) {
          return const SizedBox.shrink();
        }
        
        // Check if the time has changed
        if (_previousTime != gameProvider.remainingTime) {
          _previousTime = gameProvider.remainingTime;
          
          // Check if time is low (less than 10 seconds)
          if (gameProvider.remainingTime <= 10 && !_isLowTime) {
            _isLowTime = true;
            _pulseController.forward();
          } else if (gameProvider.remainingTime > 10 && _isLowTime) {
            _isLowTime = false;
            _pulseController.stop();
            _pulseController.reset();
          }
        }
        
        // Calculate the progress
        final progress = gameProvider.remainingTime / 60.0;
        
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Display the score and question count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Score
                  _buildInfoCard(
                    context,
                    icon: Icons.star,
                    iconColor: Colors.amber,
                    label: 'Score',
                    value: '${gameProvider.score}',
                  ),
                  
                  // Question count
                  _buildInfoCard(
                    context,
                    icon: Icons.question_answer,
                    iconColor: Theme.of(context).colorScheme.primary,
                    label: 'Questions',
                    value: '${gameProvider.questionsAnswered}/${gameProvider.maxQuestions}',
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Display the timer
              Row(
                children: [
                  // Timer icon with pulse animation
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _isLowTime ? _pulseAnimation.value : 1.0,
                        child: Icon(
                          Icons.timer,
                          color: _getTimerColor(progress),
                          size: 24,
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Timer progress bar
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Timer label
                        Text(
                          'Time Remaining',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        
                        const SizedBox(height: 4),
                        
                        // Progress bar
                        Stack(
                          children: [
                            // Background
                            Container(
                              height: 12,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceVariant,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            
                            // Progress
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: 12,
                              width: MediaQuery.of(context).size.width * progress * 0.7, // Adjust for padding
                              decoration: BoxDecoration(
                                color: _getTimerColor(progress),
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(
                                    color: _getTimerColor(progress).withOpacity(0.4),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Timer text with pulse animation
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _isLowTime ? _pulseAnimation.value : 1.0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getTimerColor(progress).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${gameProvider.remainingTime}s',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _getTimerColor(progress),
                            ),
                          ),
                        ),
                      );
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
  
  /// Build an info card for score or question count
  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
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

/// A circular timer display widget
class CircularTimerDisplay extends StatelessWidget {
  /// The progress value (0.0 to 1.0)
  final double progress;
  
  /// The remaining time in seconds
  final int remainingTime;
  
  /// The size of the timer
  final double size;
  
  /// The stroke width of the timer
  final double strokeWidth;

  /// Constructor
  const CircularTimerDisplay({
    super.key,
    required this.progress,
    required this.remainingTime,
    this.size = 80,
    this.strokeWidth = 8,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // Background circle
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: strokeWidth,
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
              ),
            ),
          ),
          
          // Progress circle
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: strokeWidth,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(_getTimerColor(progress)),
            ),
          ),
          
          // Time text
          Center(
            child: Text(
              '$remainingTime',
              style: TextStyle(
                fontSize: size * 0.3,
                fontWeight: FontWeight.bold,
                color: _getTimerColor(progress),
              ),
            ),
          ),
        ],
      ),
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
