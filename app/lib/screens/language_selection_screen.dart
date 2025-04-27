import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:language_pack/language_pack.dart';

import 'home_screen.dart';
import '../widgets/animated_language_card.dart';

/// A screen that allows the user to select a language before starting the game
class LanguageSelectionScreen extends StatelessWidget {
  /// Constructor
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Language'),
      ),
      body: Consumer<LanguageService>(
        builder: (context, languageService, _) {
          final supportedLanguages = languageService.supportedLanguages;
          
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to Gesture Charades!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Please select your preferred language:',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Language selection cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: supportedLanguages.map((language) {
                      return _buildLanguageCard(context, languageService, language);
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  /// Build a card for a language
  Widget _buildLanguageCard(
    BuildContext context, 
    LanguageService languageService, 
    LanguageModel language
  ) {
    final isSelected = languageService.selectedLanguage.code == language.code;
    
    return AnimatedLanguageCard(
      language: language,
      isSelected: isSelected,
      onTap: () {
        // Change the language
        languageService.changeLanguage(language);
        
        // Navigate to the home screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      },
    );
  }
}
