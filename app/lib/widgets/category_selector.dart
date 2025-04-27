import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:core_models/core_models.dart';

import '../providers/game_provider.dart';

/// A widget that allows the user to select a word category
class CategorySelector extends StatelessWidget {
  /// Constructor
  const CategorySelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, _) {
        // If the game is active, don't show the category selector
        if (gameProvider.isGameActive) {
          return const SizedBox.shrink();
        }
        
        // Get all available categories
        final categories = WordCategory.values;
        
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Category:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              // Display the categories in a wrap layout
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((category) {
                  final isSelected = gameProvider.selectedCategory == category;
                  
                  return FilterChip(
                    label: Text(category.toString().split('.').last),
                    selected: isSelected,
                    onSelected: (_) {
                      gameProvider.setCategory(category);
                    },
                    backgroundColor: Theme.of(context).brightness == Brightness.dark 
                      ? Theme.of(context).colorScheme.surfaceContainerHighest
                      : Colors.grey[200],
                    selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    checkmarkColor: Theme.of(context).colorScheme.primary,
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
