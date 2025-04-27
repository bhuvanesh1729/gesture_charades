import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:language_pack/language_pack.dart';

import 'screens/language_selection_screen.dart';
import 'providers/game_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/team_provider.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageService()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => TeamProvider()),
        ChangeNotifierProxyProvider<LanguageService, GameProvider>(
          create: (context) => GameProvider(
            Provider.of<LanguageService>(context, listen: false),
          ),
          update: (context, languageService, previous) => 
            previous ?? GameProvider(languageService),
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: 'Gesture Charades',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const LanguageSelectionScreen(),
          );
        },
      ),
    );
  }
}
