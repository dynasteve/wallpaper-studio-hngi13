import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/wallpaper_model.dart';
import '../widgets/wallpaper_button.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  List<Wallpaper> wallpapers = [];

  @override
  void initState() {
    super.initState();
    _loadWallpapers();
  }

  Future<void> _loadWallpapers() async {
    final dbWallpapers = await DatabaseHelper.instance.getWallpapers();
    setState(() {
      wallpapers = dbWallpapers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Browse Wallpapers"),
        centerTitle: true,
      ),
      body: wallpapers.isEmpty
          ? const Center(child: Text("No wallpapers found"))
          : GridView.builder(
              padding: const EdgeInsets.all(300),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // two per row
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 9 / 16, // tall phone-like shape
              ),
              itemCount: wallpapers.length,
              itemBuilder: (context, index) {
                final wallpaper = wallpapers[index];
                return WallpaperButton(
                  wallpaper: wallpaper,
                  showFavourite: true,
                  onTap: () {
                    print("Tapped ${wallpaper.imageName}");
                    // You could open a fullscreen preview here
                  },
                );
              },
            ),
    );
  }
}
