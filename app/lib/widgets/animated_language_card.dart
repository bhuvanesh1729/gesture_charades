import 'package:flutter/material.dart';
import 'package:language_pack/language_pack.dart';

/// A beautiful animated card for language selection
class AnimatedLanguageCard extends StatefulWidget {
  /// The language model to display
  final LanguageModel language;
  
  /// Whether this language is selected
  final bool isSelected;
  
  /// Callback when the card is tapped
  final VoidCallback onTap;

  /// Constructor
  const AnimatedLanguageCard({
    super.key,
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<AnimatedLanguageCard> createState() => _AnimatedLanguageCardState();
}

class _AnimatedLanguageCardState extends State<AnimatedLanguageCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    
    _rotateAnimation = Tween<double>(begin: 0, end: 0.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }
  
  @override
  void didUpdateWidget(AnimatedLanguageCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Start animation if selected
    if (widget.isSelected && _controller.status != AnimationStatus.completed) {
      _controller.forward();
    } else if (!widget.isSelected && _controller.status != AnimationStatus.dismissed) {
      _controller.reverse();
    }
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotateAnimation.value,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 160,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: widget.isSelected
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primaryContainer,
                      Theme.of(context).colorScheme.primary.withOpacity(0.7),
                    ],
                  )
                : null,
            color: widget.isSelected 
                ? null 
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: widget.isSelected
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.4)
                    : Colors.black.withOpacity(0.1),
                blurRadius: widget.isSelected ? 10 : 5,
                spreadRadius: widget.isSelected ? 1 : 0,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: widget.isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline.withOpacity(0.5),
              width: widget.isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Flag emoji with animated container
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.isSelected
                      ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.9)
                      : Theme.of(context).colorScheme.surfaceVariant,
                  shape: BoxShape.circle,
                  boxShadow: widget.isSelected
                      ? [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  widget.language.flagEmoji,
                  style: const TextStyle(fontSize: 36),
                ),
              ),
              const SizedBox(height: 12),
              
              // Language name
              Text(
                widget.language.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: widget.isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              
              // Selected indicator
              if (widget.isSelected) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                          size: 14,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          'Selected',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
