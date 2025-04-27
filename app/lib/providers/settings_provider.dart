import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for app settings
class SettingsProvider extends ChangeNotifier {
  /// Key for storing dark mode preference
  static const String _darkModeKey = 'dark_mode';
  
  /// Key for storing sound effects preference
  static const String _soundEffectsKey = 'sound_effects';
  
  /// Key for storing vibration preference
  static const String _vibrationKey = 'vibration';
  
  /// Key for storing timer duration preference
  static const String _timerDurationKey = 'timer_duration';
  
  /// Key for storing number of questions preference
  static const String _questionCountKey = 'question_count';
  
  /// Whether dark mode is enabled
  bool _isDarkMode = false;
  
  /// Whether sound effects are enabled
  bool _soundEffectsEnabled = true;
  
  /// Whether vibration is enabled
  bool _vibrationEnabled = true;
  
  /// Timer duration in seconds
  int _timerDuration = 60;
  
  /// Number of questions per game
  int _questionCount = 10;
  
  /// SharedPreferences instance
  late SharedPreferences _prefs;
  
  /// Constructor
  SettingsProvider() {
    _loadSettings();
  }
  
  /// Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    
    _isDarkMode = _prefs.getBool(_darkModeKey) ?? false;
    _soundEffectsEnabled = _prefs.getBool(_soundEffectsKey) ?? true;
    _vibrationEnabled = _prefs.getBool(_vibrationKey) ?? true;
    _timerDuration = _prefs.getInt(_timerDurationKey) ?? 60;
    _questionCount = _prefs.getInt(_questionCountKey) ?? 10;
    
    notifyListeners();
  }
  
  /// Whether dark mode is enabled
  bool get isDarkMode => _isDarkMode;
  
  /// Whether sound effects are enabled
  bool get soundEffectsEnabled => _soundEffectsEnabled;
  
  /// Whether vibration is enabled
  bool get vibrationEnabled => _vibrationEnabled;
  
  /// Timer duration in seconds
  int get timerDuration => _timerDuration;
  
  /// Number of questions per game
  int get questionCount => _questionCount;
  
  /// Set dark mode
  Future<void> setDarkMode(bool value) async {
    if (_isDarkMode == value) return;
    
    _isDarkMode = value;
    await _prefs.setBool(_darkModeKey, value);
    notifyListeners();
  }
  
  /// Set sound effects
  Future<void> setSoundEffects(bool value) async {
    if (_soundEffectsEnabled == value) return;
    
    _soundEffectsEnabled = value;
    await _prefs.setBool(_soundEffectsKey, value);
    notifyListeners();
  }
  
  /// Set timer duration
  Future<void> setTimerDuration(int seconds) async {
    if (_timerDuration == seconds) return;
    
    _timerDuration = seconds;
    await _prefs.setInt(_timerDurationKey, seconds);
    notifyListeners();
  }
  
  /// Set vibration
  Future<void> setVibrationEnabled(bool value) async {
    if (_vibrationEnabled == value) return;
    
    _vibrationEnabled = value;
    await _prefs.setBool(_vibrationKey, value);
    notifyListeners();
  }
  
  /// Set number of questions per game
  Future<void> setQuestionCount(int count) async {
    if (_questionCount == count) return;
    
    _questionCount = count;
    await _prefs.setInt(_questionCountKey, count);
    notifyListeners();
  }
}
