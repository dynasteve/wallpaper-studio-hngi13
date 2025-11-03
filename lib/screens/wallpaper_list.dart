
import 'package:flutter/material.dart';
import 'package:hngi13_stage3_wallpaperstudio/db/database_helper.dart';
import 'package:hngi13_stage3_wallpaperstudio/models/wallpaper_model.dart';

class WallpaperList extends StatefulWidget {
  const WallpaperList({super.key});

  @override
  State<WallpaperList> createState() => _WallpaperListState();
}

class _WallpaperListState extends State<WallpaperList> {
  late Future<List<Wallpaper>> wallpapersFuture;

  @override
  void initState() {
    super.initState();
    wallpapersFuture = DatabaseHelper.instance.getWallpapers();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Wallpaper>>(
      future: wallpapersFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final wallpapers = snapshot.data!;

        return ListView.builder(
          itemCount: wallpapers.length,
          itemBuilder: (context, index) {
            final w = wallpapers[index];
            return ListTile(
              leading: Image.asset(w.imagePath, width: 60),
              title: Text(w.category),
              subtitle: Text(w.isFavourite ? "❤️ Favourite" : "♡ Not Favourite"),
              trailing: IconButton(
                icon: Icon(Icons.favorite, color: w.isFavourite ? Colors.red : Colors.grey),
                onPressed: () async {
                  await DatabaseHelper.instance.toggleFavourite(w.id!, w.isFavourite);
                  setState(() {
                    wallpapersFuture = DatabaseHelper.instance.getWallpapers();
                  });
                },
              ),
            );
          },
        );
      },
    );
  }
}
