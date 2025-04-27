import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for managing team scores and settings
class TeamProvider extends ChangeNotifier {
  /// Key for storing team 1 score
  static const String _team1ScoreKey = 'team1_score';
  
  /// Key for storing team 2 score
  static const String _team2ScoreKey = 'team2_score';
  
  /// Key for storing active team
  static const String _activeTeamKey = 'active_team';
  
  /// Key for storing team mode enabled
  static const String _teamModeEnabledKey = 'team_mode_enabled';
  
  /// Team 1 score
  int _team1Score = 0;
  
  /// Team 2 score
  int _team2Score = 0;
  
  /// Active team (1 or 2)
  int _activeTeam = 1;
  
  /// Whether team mode is enabled
  bool _teamModeEnabled = true;
  
  /// Team 1 name
  String _team1Name = 'Team 1';
  
  /// Team 2 name
  String _team2Name = 'Team 2';
  
  /// SharedPreferences instance
  late SharedPreferences _prefs;
  
  /// Constructor
  TeamProvider() {
    _loadSettings();
  }
  
  /// Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    
    _team1Score = _prefs.getInt(_team1ScoreKey) ?? 0;
    _team2Score = _prefs.getInt(_team2ScoreKey) ?? 0;
    _activeTeam = _prefs.getInt(_activeTeamKey) ?? 1;
    _teamModeEnabled = _prefs.getBool(_teamModeEnabledKey) ?? true;
    
    notifyListeners();
  }
  
  /// Get team 1 score
  int get team1Score => _team1Score;
  
  /// Get team 2 score
  int get team2Score => _team2Score;
  
  /// Get active team
  int get activeTeam => _activeTeam;
  
  /// Whether team mode is enabled
  bool get teamModeEnabled => _teamModeEnabled;
  
  /// Get team 1 name
  String get team1Name => _team1Name;
  
  /// Get team 2 name
  String get team2Name => _team2Name;
  
  /// Set team 1 name
  void setTeam1Name(String name) {
    _team1Name = name;
    notifyListeners();
  }
  
  /// Set team 2 name
  void setTeam2Name(String name) {
    _team2Name = name;
    notifyListeners();
  }
  
  /// Toggle team mode
  Future<void> setTeamModeEnabled(bool enabled) async {
    if (_teamModeEnabled == enabled) return;
    
    _teamModeEnabled = enabled;
    await _prefs.setBool(_teamModeEnabledKey, enabled);
    notifyListeners();
  }
  
  /// Switch active team
  Future<void> switchActiveTeam() async {
    _activeTeam = _activeTeam == 1 ? 2 : 1;
    await _prefs.setInt(_activeTeamKey, _activeTeam);
    notifyListeners();
  }
  
  /// Add points to the active team
  Future<void> addPointsToActiveTeam(int points) async {
    if (_activeTeam == 1) {
      _team1Score += points;
      await _prefs.setInt(_team1ScoreKey, _team1Score);
    } else {
      _team2Score += points;
      await _prefs.setInt(_team2ScoreKey, _team2Score);
    }
    notifyListeners();
  }
  
  /// Reset scores
  Future<void> resetScores() async {
    _team1Score = 0;
    _team2Score = 0;
    await _prefs.setInt(_team1ScoreKey, 0);
    await _prefs.setInt(_team2ScoreKey, 0);
    notifyListeners();
  }
}
