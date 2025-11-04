import './db/database_helper.dart';
import './models/wallpaper_model.dart';

Future<void> populateDB() async {
  final db = DatabaseHelper.instance;

  // Optional: clear existing data
  await db.deleteAll();

  // Helper to insert wallpaper quickly
  Future<void> addWallpaper({
    required String imagePath,
    required String imageName,
    required String category,
    required String description,
    required List<String> tags,
  }) async {
    final previewPath = imagePath.replaceAll(
      'assets/wallpapers/',
      'assets/wallpapers/previews/',
    );

    await db.insertWallpaper(
      Wallpaper(
        imagePath: imagePath,
        previewPath: previewPath,
        imageName: imageName,
        category: category,
        description: description,
        tags: tags,
      ),
    );
  }

  // 🌿 Nature Wallpapers
  const natureDesc =
      "Immerse yourself in the calming essence of nature with lush forests, serene lakes, and mountain peaks.";
  for (int i = 1; i <= 6; i++) {
    await addWallpaper(
      imagePath: 'assets/wallpapers/nature/nature-$i.jpg',
      imageName: 'Nature $i',
      category: 'Nature',
      description: natureDesc,
      tags: ['Nature', 'Ambience', 'Flowers'],
    );
  }

  // 🏙️ Urban Wallpapers
  const urbanDesc =
      "Experience the pulse of city life with stunning skylines, street lights, and urban textures.";
  for (int i = 1; i <= 6; i++) {
    await addWallpaper(
      imagePath: 'assets/wallpapers/urban/urban-$i.jpg',
      imageName: 'Urban $i',
      category: 'Urban',
      description: urbanDesc,
      tags: ['City', 'Architecture', 'Nightlife'],
    );
  }

  // 🚀 Space Wallpapers
  const spaceDesc =
      "Explore the mysteries of the cosmos with galaxies, nebulae, and star-filled wonders.";
  for (int i = 1; i <= 6; i++) {
    await addWallpaper(
      imagePath: 'assets/wallpapers/space/space-$i.jpg',
      imageName: 'Space $i',
      category: 'Space',
      description: spaceDesc,
      tags: ['Space', 'Galaxy', 'Cosmos'],
    );
  }

  print("Database populated with sample wallpapers!");
}
