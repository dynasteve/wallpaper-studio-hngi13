import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

void main() async {
  // Must ensure widgets binding is initialized before async operations
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize FFI (for desktop platforms)
  sqfliteFfiInit();

  // ✅ Assign the FFI database factory
  databaseFactory = databaseFactoryFfi;

  // (Optional) You can open your database here or in a DatabaseHelper class
  final dir = await getApplicationDocumentsDirectory();
  final dbPath = p.join(dir.path, 'wallpaper_app.db');
  final db = await databaseFactory.openDatabase(dbPath);

  // Debug print
  print('Database initialized at $dbPath');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallpaper App',
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Center(child: Text('Database initialized successfully!')),
      ),
    );
  }
}
