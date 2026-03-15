import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class C {
  static const bg = Color(0xFFF7F5FF);
  static const surface = Color(0xFFFFFFFF);
  static const accent = Color(0xFF6C47FF);
  static const accent2 = Color(0xFF9B7FFF);
  static const accentSoft = Color(0xFFEDE9FF);
  static const green = Color(0xFF00C48C);
  static const greenSoft = Color(0xFFE0FBF3);
  static const orange = Color(0xFFFF8C42);
  static const orangeSoft = Color(0xFFFFF0E6);
  static const red = Color(0xFFFF4D6A);
  static const redSoft = Color(0xFFFFE9ED);
  static const dark = Color(0xFF1A1535);
  static const text = Color(0xFF2D2550);
  static const muted = Color(0xFF9691B0);
  static const border = Color(0xFFE8E4F8);
}

ThemeData scriviaTheme() {
  return ThemeData(
    scaffoldBackgroundColor: C.bg,
    useMaterial3: true,
    textTheme: GoogleFonts.nunitoTextTheme().copyWith(
      displayLarge: GoogleFonts.syne(fontWeight: FontWeight.w800),
      displayMedium: GoogleFonts.syne(fontWeight: FontWeight.w800),
      headlineLarge: GoogleFonts.syne(fontWeight: FontWeight.w800),
      headlineMedium: GoogleFonts.syne(fontWeight: FontWeight.w700),
    ),
    colorScheme: const ColorScheme.light(
      primary: C.accent,
      secondary: C.accent2,
      surface: C.surface,
    ),
  );
}

// ─── WIDGETS COMMUNS ─────────────────────────────────────────
class SCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? color;
  final VoidCallback? onTap;

  const SCard({super.key, required this.child, this.padding, this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color ?? C.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: C.dark.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class SBadge extends StatelessWidget {
  final String text;
  final Color color;
  final Color? bg;

  const SBadge({super.key, required this.text, required this.color, this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg ?? color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
    );
  }
}

class SProgressBar extends StatelessWidget {
  final double value;
  final Color color;
  final double height;

  const SProgressBar({super.key, required this.value, required this.color, this.height = 4});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: LinearProgressIndicator(
        value: value,
        backgroundColor: C.border,
        valueColor: AlwaysStoppedAnimation(color),
        minHeight: height,
      ),
    );
  }
}