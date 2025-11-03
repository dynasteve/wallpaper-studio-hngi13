import 'package:sqflite/sqflite.dart';

class Wallpaper {
  final int? id;
  final String imageName;
  final String imagePath;
  final String category;
  final bool isFavourite;
  final bool isActive;
  final String? description;
  final List<String>? tags;
  final String? previewPath;

  Wallpaper({
    this.id,
    required this.imageName,
    required this.imagePath,
    required this.category,
    this.isFavourite = false,
    this.isActive = false,
    this.description,
    this.tags,
    this.previewPath,
  });

  factory Wallpaper.fromMap(Map<String, dynamic> map) {
    // Normalize tags
    final rawTags = map['tags'];
    List<String>? parsedTags;
    if (rawTags is String) {
      parsedTags = rawTags
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList();
    } else if (rawTags is List) {
      parsedTags = rawTags.map((e) => e.toString()).toList();
    }

    return Wallpaper(
      id: map['id'] as int?,
      imageName: map['imageName'] ?? '',
      imagePath: map['imagePath'] ?? '',
      category: map['category'] ?? '',
      isFavourite: (map['isFavourite'] ?? 0) == 1,
      isActive: (map['isActive'] ?? 0) == 1,
      description: map['description'] ?? '',
      tags: parsedTags,
      previewPath: map['previewPath'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageName': imageName,
      'imagePath': imagePath,
      'category': category,
      'isFavourite': isFavourite ? 1 : 0,
      'isActive': isActive ? 1 : 0,
      'description': description ?? '',
      'tags': tags?.join(',') ?? '',
      'previewPath': previewPath,
    };
  }



    /// Returns number of wallpapers in [categoryName]
  static Future<int> getCountByCategory(Database db, String categoryName) async {
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM wallpapers WHERE category = ?',
      [categoryName],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}

