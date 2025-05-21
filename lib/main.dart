import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/theme_provider.dart';
import 'screens/home_screen.dart'; // This is the one you want to use
import 'services/hive_service.dart';
import 'models/query_model.dart';
import 'providers/query_provider.dart';
import "screens/add_query_screen.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.initHive(); // ✅ Init Hive before runApp
  final box = HiveService.queryBox;

  runApp(
    MultiProvider(
      // Use MultiProvider
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => QueryProvider()), // Add this
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Student Expense Tracker',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(), // ✅ This now refers to the imported one
    );
  }
}
