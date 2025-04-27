import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:language_pack/language_pack.dart';

/// A widget that allows the user to select a language
class LanguageSelector extends StatelessWidget {
  /// Constructor
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, _) {
        final currentLanguage = languageService.selectedLanguage;
        final supportedLanguages = languageService.supportedLanguages;
        
        return PopupMenuButton<LanguageModel>(
          tooltip: 'Select Language',
          icon: const Icon(Icons.language),
          initialValue: currentLanguage,
          onSelected: (LanguageModel language) {
            languageService.changeLanguage(language);
          },
          itemBuilder: (BuildContext context) {
            return supportedLanguages.map((LanguageModel language) {
              return PopupMenuItem<LanguageModel>(
                value: language,
                child: Row(
                  children: [
                    // Show a checkmark for the current language
                    if (language.code == currentLanguage.code)
                      const Icon(Icons.check, size: 18, color: Colors.green)
                    else
                      const SizedBox(width: 18),
                    const SizedBox(width: 8),
                    // Display the language name
                    Text(language.name),
                  ],
                ),
              );
            }).toList();
          },
        );
      },
    );
  }
  
  /// Get the display name for a language code
  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      case 'de':
        return 'Deutsch';
      case 'it':
        return 'Italiano';
      case 'pt':
        return 'Português';
      case 'ru':
        return 'Русский';
      case 'zh':
        return '中文';
      case 'ja':
        return '日本語';
      case 'ko':
        return '한국어';
      case 'hi':
        return 'हिन्दी';
      default:
        return languageCode;
    }
  }
}
