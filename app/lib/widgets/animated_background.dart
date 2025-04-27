import 'dart:math';
import 'package:flutter/material.dart';

/// A widget that displays an animated background with grid and particles
class AnimatedBackground extends StatefulWidget {
  /// The child widget to display on top of the background
  final Widget child;
  
  /// The number of particles to display
  final int particleCount;
  
  /// The color of the grid lines
  final Color gridColor;
  
  /// The color of the particles
  final Color particleColor;
  
  /// The size of the grid cells
  final double gridSize;
  
  /// Constructor
  const AnimatedBackground({
    super.key,
    required this.child,
    this.particleCount = 30,
    this.gridColor = const Color(0x0AFFFFFF),
    this.particleColor = const Color(0x3F6C63FF),
    this.gridSize = 24,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;
  final Random _random = Random();
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    
    _particles = List.generate(
      widget.particleCount,
      (_) => Particle.random(_random),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Grid background
        CustomPaint(
          painter: GridPainter(
            color: widget.gridColor,
            gridSize: widget.gridSize,
          ),
          child: Container(),
        ),
        
        // Animated particles
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              painter: ParticlePainter(
                particles: _particles,
                progress: _controller.value,
                color: widget.particleColor,
              ),
              child: Container(),
            );
          },
        ),
        
        // Child content
        widget.child,
      ],
    );
  }
}

/// A class representing a particle in the background
class Particle {
  /// The starting position of the particle
  final Offset start;
  
  /// The ending position of the particle
  final Offset end;
  
  /// The size of the particle
  final double size;
  
  /// The opacity of the particle
  final double opacity;
  
  /// The speed of the particle
  final double speed;
  
  /// Constructor
  Particle({
    required this.start,
    required this.end,
    required this.size,
    required this.opacity,
    required this.speed,
  });
  
  /// Create a random particle
  factory Particle.random(Random random) {
    final startX = random.nextDouble();
    final startY = random.nextDouble();
    final endX = startX + (random.nextDouble() - 0.5) * 0.3;
    final endY = startY + (random.nextDouble() - 0.5) * 0.3;
    
    return Particle(
      start: Offset(startX, startY),
      end: Offset(endX, endY),
      size: random.nextDouble() * 3 + 1,
      opacity: random.nextDouble() * 0.6 + 0.2,
      speed: random.nextDouble() * 0.8 + 0.2,
    );
  }
  
  /// Get the current position of the particle based on the progress
  Offset getCurrentPosition(double progress) {
    final cycleProgress = (progress * speed) % 1.0;
    final reverseCycle = cycleProgress > 0.5 
        ? 1.0 - (cycleProgress - 0.5) * 2 
        : cycleProgress * 2;
    
    return Offset.lerp(start, end, reverseCycle)!;
  }
}

/// A painter for drawing the grid background
class GridPainter extends CustomPainter {
  /// The color of the grid lines
  final Color color;
  
  /// The size of the grid cells
  final double gridSize;
  
  /// Constructor
  GridPainter({
    required this.color,
    required this.gridSize,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    
    // Draw vertical lines
    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
    
    // Draw horizontal lines
    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// A painter for drawing the particles
class ParticlePainter extends CustomPainter {
  /// The list of particles to draw
  final List<Particle> particles;
  
  /// The progress of the animation (0.0 to 1.0)
  final double progress;
  
  /// The color of the particles
  final Color color;
  
  /// Constructor
  ParticlePainter({
    required this.particles,
    required this.progress,
    required this.color,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final position = particle.getCurrentPosition(progress);
      final paint = Paint()
        ..color = color.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(
        Offset(position.dx * size.width, position.dy * size.height),
        particle.size,
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) => true;
}

/// A widget that adds a gradient overlay to its child
class GradientOverlay extends StatelessWidget {
  /// The child widget
  final Widget child;
  
  /// The gradient to apply
  final Gradient gradient;
  
  /// Constructor
  const GradientOverlay({
    super.key,
    required this.child,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(bounds),
      blendMode: BlendMode.srcATop,
      child: child,
    );
  }
}

/// A widget that adds a glowing effect to its child
class GlowingContainer extends StatelessWidget {
  /// The child widget
  final Widget child;
  
  /// The glow color
  final Color glowColor;
  
  /// The border radius
  final BorderRadius borderRadius;
  
  /// Constructor
  const GlowingContainer({
    super.key,
    required this.child,
    required this.glowColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: child,
      ),
    );
  }
}
