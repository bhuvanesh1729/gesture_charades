import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'language_model.dart';
import 'supported_languages.dart';
import 'word_packs/word_pack_provider.dart';

/// Service for managing language selection and providing access to word packs
class LanguageService extends ChangeNotifier {
  /// Key for storing the selected language code in SharedPreferences
  static const String _languageCodeKey = 'selected_language_code';
  
  /// The currently selected language
  LanguageModel _selectedLanguage = SupportedLanguages.english;
  
  /// The word pack provider for the current language
  late WordPackProvider _wordPackProvider;
  
  /// SharedPreferences instance for persisting language selection
  late SharedPreferences _prefs;
  
  /// Completer for initialization
  final Completer<void> _initCompleter = Completer<void>();
  
  /// Future that completes when the service is initialized
  Future<void> get initialized => _initCompleter.future;
  
  /// Constructor
  LanguageService() {
    _init();
  }
  
  /// Initialize the service
  Future<void> _init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      
      // Load the saved language code or use English as default
      final savedCode = _prefs.getString(_languageCodeKey) ?? 'en';
      _selectedLanguage = SupportedLanguages.getByCode(savedCode);
      
      // Initialize the word pack provider
      _wordPackProvider = WordPackProvider(_selectedLanguage.code);
      
      _initCompleter.complete();
    } catch (e) {
      _initCompleter.completeError(e);
    }
  }
  
  /// Get the currently selected language
  LanguageModel get selectedLanguage => _selectedLanguage;
  
  /// Get the word pack provider for the current language
  WordPackProvider get wordPackProvider => _wordPackProvider;
  
  /// Get the list of all supported languages
  List<LanguageModel> get supportedLanguages => SupportedLanguages.allLanguages;
  
  /// Change the selected language
  Future<void> changeLanguage(LanguageModel language) async {
    if (_selectedLanguage.code == language.code) return;
    
    _selectedLanguage = language;
    _wordPackProvider = WordPackProvider(language.code);
    
    // Save the selection to SharedPreferences
    await _prefs.setString(_languageCodeKey, language.code);
    
    // Notify listeners about the change
    notifyListeners();
  }
}
