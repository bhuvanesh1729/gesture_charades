import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:language_pack/language_pack.dart';
import 'package:core_models/core_models.dart';
import 'package:provider/provider.dart';

import 'team_provider.dart';

/// Provider for game state
class GameProvider extends ChangeNotifier {
  /// The language service
  final LanguageService _languageService;
  
  /// The current word
  Word? _currentWord;
  
  /// The score
  int _score = 0;
  
  /// The timer
  Timer? _timer;
  
  /// The remaining time in seconds
  int _remainingTime = 60;
  
  /// Whether the game is active
  bool _isGameActive = false;
  
  /// The selected category
  WordCategory? _selectedCategory;
  
  /// The number of questions answered in the current game
  int _questionsAnswered = 0;
  
  /// The maximum number of questions per game
  int _maxQuestions = 10;
  
  /// Whether the game is in team mode
  bool _isTeamMode = false;
  
  /// Whether team 1 has finished their turn
  bool _isTeam1Finished = false;
  
  /// The final score for team 1
  int _team1FinalScore = 0;
  
  /// The final score for team 2
  int _team2FinalScore = 0;
  
  /// Whether the game is completely finished (both teams have played)
  bool _isGameFinished = false;
  
  /// Constructor
  GameProvider(this._languageService) {
    _init();
  }
  
  /// Initialize the provider
  Future<void> _init() async {
    await _languageService.initialized;
  }
  
  /// Get the current word
  Word? get currentWord => _currentWord;
  
  /// Get the score
  int get score => _score;
  
  /// Get the remaining time
  int get remainingTime => _remainingTime;
  
  /// Whether the game is active
  bool get isGameActive => _isGameActive;
  
  /// Get the selected category
  WordCategory? get selectedCategory => _selectedCategory;
  
  /// Get the number of questions answered
  int get questionsAnswered => _questionsAnswered;
  
  /// Get the maximum number of questions
  int get maxQuestions => _maxQuestions;
  
  /// Whether the game is in team mode
  bool get isTeamMode => _isTeamMode;
  
  /// Whether team 1 has finished their turn
  bool get isTeam1Finished => _isTeam1Finished;
  
  /// Get the final score for team 1
  int get team1FinalScore => _team1FinalScore;
  
  /// Get the final score for team 2
  int get team2FinalScore => _team2FinalScore;
  
  /// Whether the game is completely finished (both teams have played)
  bool get isGameFinished => _isGameFinished;
  
  /// Set the selected category
  void setCategory(WordCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }
  
  /// Start the game
  void startGame(int timerDuration, {int? questionCount, bool? isTeamMode}) {
    _score = 0;
    _remainingTime = timerDuration;
    _isGameActive = true;
    _questionsAnswered = 0;
    
    // Set the maximum number of questions if provided
    if (questionCount != null) {
      _maxQuestions = questionCount;
    }
    
    // Set team mode if provided
    if (isTeamMode != null) {
      _isTeamMode = isTeamMode;
    }
    
    // Reset team-related flags if starting a new game
    if (!_isTeam1Finished || _isGameFinished) {
      _isTeam1Finished = false;
      _isGameFinished = false;
      _team1FinalScore = 0;
      _team2FinalScore = 0;
    }
    
    // Get the first word
    _nextWord();
    
    // Start the timer
    _startTimer();
    
    notifyListeners();
  }
  
  /// End the game
  void endGame() {
    _isGameActive = false;
    _timer?.cancel();
    _timer = null;
    notifyListeners();
  }
  
  /// Move to the next word
  void nextWord() {
    if (!_isGameActive) return;
    
    _questionsAnswered++;
    
    // Check if we've reached the maximum number of questions
    if (_questionsAnswered >= _maxQuestions) {
      _handleGameRoundEnd();
      return;
    }
    
    _nextWord();
    notifyListeners();
  }
  
  /// Mark the current word as correct
  void markCorrect() {
    if (!_isGameActive) return;
    
    _score++;
    _questionsAnswered++;
    
    // Check if we've reached the maximum number of questions
    if (_questionsAnswered >= _maxQuestions) {
      _handleGameRoundEnd();
      return;
    }
    
    _nextWord();
    notifyListeners();
  }
  
  /// Handle the end of a game round
  void _handleGameRoundEnd() {
    // If team mode is enabled and team 1 just finished
    if (_isTeamMode && !_isTeam1Finished) {
      _team1FinalScore = _score;
      _isTeam1Finished = true;
      endGame();
      
      // Show a dialog to start team 2's turn
      // This will be handled in the UI
    } 
    // If team mode is enabled and team 2 just finished
    else if (_isTeamMode && _isTeam1Finished) {
      _team2FinalScore = _score;
      _isGameFinished = true;
      endGame();
      
      // Show the final results
      // This will be handled in the UI
    }
    // If not in team mode, just end the game
    else {
      endGame();
    }
  }
  
  /// Start the timer
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime <= 0) {
        endGame();
        return;
      }
      
      _remainingTime--;
      notifyListeners();
    });
  }
  
  /// Reset the timer
  void resetTimer(int timerDuration) {
    _remainingTime = timerDuration;
    _startTimer();
    notifyListeners();
  }
  
  /// Get the next word
  void _nextWord() {
    final wordPackProvider = _languageService.wordPackProvider;
    
    if (_selectedCategory != null) {
      _currentWord = wordPackProvider.getRandomWordFromCategory(_selectedCategory!);
    } else {
      _currentWord = wordPackProvider.getRandomWord();
    }
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
