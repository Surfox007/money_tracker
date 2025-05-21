import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors
  static const Color primary = Color(0xFF6C63FF); // Modern purple
  static const Color secondary = Color(0xFF03DAC6); // Teal accent
  static const Color error = Color(0xFFCF6679); // Error red

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2D2D2D);
  static const Color darkDivider = Color(0xFF3D3D3D);

  // Text Colors
  static const Color darkTextPrimary = Color(0xFFE1E1E1);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);

  // Transaction Type Colors
  static const Color expenseColor = Color(0xFFFF5252);
  static const Color lentColor = Color(0xFF4CAF50);
  static const Color borrowedColor = Color(0xFFFFB74D);

  // Card Styles
  static final cardDecoration = BoxDecoration(
    color: darkCard,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // Input Decoration
  static InputDecoration inputDecoration({
    required String hintText,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      filled: true,
      fillColor: darkSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  // Button Styles
  static final elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primary,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 0,
  );

  static final textButtonStyle = TextButton.styleFrom(
    foregroundColor: primary,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  // Dashboard Card Style
  static final dashboardCardDecoration = BoxDecoration(
    color: darkCard,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: darkDivider, width: 1),
  );

  // List Tile Style
  static final listTileTheme = ListTileThemeData(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );

  // App Bar Style
  static final appBarTheme = AppBarTheme(
    backgroundColor: darkBackground,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: darkTextPrimary,
    ),
    iconTheme: const IconThemeData(color: darkTextPrimary),
  );

  // Bottom Navigation Bar Style
  static final bottomNavigationBarTheme = BottomNavigationBarThemeData(
    backgroundColor: darkSurface,
    selectedItemColor: primary,
    unselectedItemColor: darkTextSecondary,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  );

  // Floating Action Button Style
  static final floatingActionButtonTheme = FloatingActionButtonThemeData(
    backgroundColor: primary,
    foregroundColor: Colors.white,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  );
} 