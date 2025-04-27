import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:language_pack/language_pack.dart';

import 'providers/game_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/team_provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

/// Production environment configuration
const bool isProduction = true;

/// Entry point for the production app
void main() {
  // Set up error handling for production
  FlutterError.onError = (FlutterErrorDetails details) {
    // In production, errors could be sent to a crash reporting service
    FlutterError.dumpErrorToConsole(details);
  };

  runApp(const GestureCharadesApp());
}

/// The main app widget
class GestureCharadesApp extends StatelessWidget {
  /// Constructor
  const GestureCharadesApp({super.key});

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
      child: MaterialApp(
        title: 'Gesture Charades',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false, // No debug banner in production
      ),
    );
  }
}
