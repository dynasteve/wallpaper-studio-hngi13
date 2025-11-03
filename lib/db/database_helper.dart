import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../models/wallpaper_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('wallpapers.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // ✅ Initialize FFI if on desktop (Windows, macOS, Linux)
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, filePath);

    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 2, // bumped version for new fields
        onCreate: _createDB,
        onUpgrade: _upgradeDB,
      ),
    );
  }

Future _createDB(Database db, int version) async {
  await db.execute('''
    CREATE TABLE wallpapers (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      imageName TEXT NOT NULL,
      imagePath TEXT NOT NULL,
      category TEXT NOT NULL,
      isFavourite INTEGER NOT NULL,
      isActive INTEGER NOT NULL,
      description TEXT,
      tags TEXT,
      previewPath TEXT
    )
  ''');
}



  // Handle DB upgrades (adds new columns if missing)
  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE wallpapers ADD COLUMN tags TEXT;');
      await db.execute('ALTER TABLE wallpapers ADD COLUMN description TEXT;');
      await db.execute('ALTER TABLE wallpapers ADD COLUMN previewPath TEXT;');
    }
  }

  // ---------------- CRUD FUNCTIONS ----------------

  Future<int> insertWallpaper(Wallpaper wallpaper) async {
    final db = await instance.database;
    return await db.insert('wallpapers', wallpaper.toMap());
  }

  Future<List<Wallpaper>> getWallpapers() async {
    final db = await instance.database;
    final result = await db.query('wallpapers');
    return result.map((map) => Wallpaper.fromMap(map)).toList();
  }

  Future<List<Wallpaper>> getWallpapersByCategory(String category) async {
    final db = await instance.database;
    final result =
        await db.query('wallpapers', where: 'category = ?', whereArgs: [category]);
    return result.map((map) => Wallpaper.fromMap(map)).toList();
  }

  Future<List<Wallpaper>> getFavourites() async {
    final db = await instance.database;
    final result = await db.query(
      'wallpapers',
      where: 'isFavourite = ?',
      whereArgs: [1],
    );
    return result.map((map) => Wallpaper.fromMap(map)).toList();
  }

  Future<void> toggleFavourite(int id, bool current) async {
    final db = await instance.database;
    await db.update(
      'wallpapers',
      {'isFavourite': current ? 0 : 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> setActiveWallpaper(int id) async {
    final db = await instance.database;
    await db.update('wallpapers', {'isActive': 0});
    await db.update('wallpapers', {'isActive': 1}, where: 'id = ?', whereArgs: [id]);
  }

  Future<Wallpaper?> getActiveWallpaper() async {
    final db = await instance.database;
    final result =
        await db.query('wallpapers', where: 'isActive = ?', whereArgs: [1]);
    if (result.isNotEmpty) {
      return Wallpaper.fromMap(result.first);
    }
    return null;
  }

  Future<void> deleteAll() async {
    final db = await instance.database;
    await db.delete('wallpapers');
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }
}
