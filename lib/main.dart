import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// --- Import All Screens ---
import 'package:hngi13_stage3_wallpaperstudio/screens/home_screen.dart';
import 'package:hngi13_stage3_wallpaperstudio/screens/favourite_screen.dart';
import 'package:hngi13_stage3_wallpaperstudio/screens/browse_screen.dart';
import 'package:hngi13_stage3_wallpaperstudio/screens/wallpaper_setup.dart'; 
// Note: wallpaper_list.dart and unused model/helper imports removed for cleanliness

// --- Import Utilities ---
import 'populateDB.dart'; 

// 1. Initial setup and DB population runs before the app starts
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database for desktop platforms
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Populate DB only after initialization
  await populateDB();

  // 2. Run the main application class
  runApp(const MyApp());
}

// 3. Define the main application widget using StatelessWidget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallpaper Studio',
      theme: ThemeData(
        // Setting a global background color
        scaffoldBackgroundColor: Colors.grey[100], 
        fontFamily: 'Poppins', 
        useMaterial3: true,
      ),
      
      // Define the starting route and all named routes
      initialRoute: '/',
      routes: {
        // The main entry point, showing categories (your HomeScreen)
        '/': (context) => const HomeScreen(),
        
        // Favourites Screen
        '/favourites': (context) => const FavouriteScreen(),

        // General Browse/Search Screen (The "See All" page)
        '/browse': (context) => const BrowseScreen(),
      },
      
      // Use onGenerateRoute for dynamic routes that require arguments (like category)
      onGenerateRoute: (settings) {
        // Route for navigating into a specific category grid
        if (settings.name == '/category_setup') {
          // Arguments are expected to be the category String
          final category = settings.arguments as String?; 

          if (category != null) {
            return MaterialPageRoute(
              builder: (context) => WallpaperSetup(category: category),
            );
          }
        }
        // Fallback for unknown routes
        return null;
      },
    );
  }
}