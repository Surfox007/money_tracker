import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/hive_service.dart';
import 'providers/query_provider.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.initHive();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QueryProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppTheme.darkBackground,
        colorScheme: const ColorScheme.dark(
          primary: AppTheme.primary,
          secondary: AppTheme.secondary,
          error: AppTheme.error,
          background: AppTheme.darkBackground,
          surface: AppTheme.darkSurface,
        ),
        appBarTheme: AppTheme.appBarTheme,
        cardTheme: CardTheme(
          color: AppTheme.darkCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppTheme.darkSurface,
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
            borderSide: const BorderSide(color: AppTheme.primary, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: AppTheme.elevatedButtonStyle,
        ),
        textButtonTheme: TextButtonThemeData(
          style: AppTheme.textButtonStyle,
        ),
        bottomNavigationBarTheme: AppTheme.bottomNavigationBarTheme,
        floatingActionButtonTheme: AppTheme.floatingActionButtonTheme,
        listTileTheme: AppTheme.listTileTheme,
        dividerTheme: const DividerThemeData(
          color: AppTheme.darkDivider,
          thickness: 1,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppTheme.darkTextPrimary),
          bodyMedium: TextStyle(color: AppTheme.darkTextPrimary),
          titleLarge: TextStyle(color: AppTheme.darkTextPrimary),
          titleMedium: TextStyle(color: AppTheme.darkTextPrimary),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
