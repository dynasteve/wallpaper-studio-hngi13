import 'package:flutter/material.dart';
import 'package:hngi13_stage3_wallpaperstudio/widgets/responsive_scaffold.dart';
import 'package:hngi13_stage3_wallpaperstudio/db/database_helper.dart'; 
import 'package:hngi13_stage3_wallpaperstudio/models/wallpaper_model.dart'; 
import 'package:hngi13_stage3_wallpaperstudio/widgets/wallpaper_button.dart';
import 'package:hngi13_stage3_wallpaperstudio/widgets/title_desc.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  // ... (state and constants remain the same)
  List<Wallpaper> favoriteWallpapers = [];
  late Future<void> _fetchFavoritesFuture;

  static const double horizontalMargin = 47.0;
  static const double itemSpacing = 20.0;
  static const double minItemWidth = 180.0; 
  static const double itemAspectRatio = 9 / 14; 
  
  // Define the custom color for easy reference
  static const Color primaryColor = Color(0xffFBB03B);

  @override
  void initState() {
    super.initState();
    _fetchFavoritesFuture = _loadFavoriteWallpapers(); 
  }
  
  void refreshFavorites() {
    setState(() {
      _fetchFavoritesFuture = _loadFavoriteWallpapers();
    });
  }

  Future<void> _loadFavoriteWallpapers() async {
    final dbWallpapers = await DatabaseHelper.instance.getFavourites(); 

    if (mounted) {
      setState(() {
        favoriteWallpapers = dbWallpapers;
      });
    }
  }

  void _handleFavoriteToggle(Wallpaper wallpaper) async {
    await DatabaseHelper.instance.toggleFavourite(wallpaper.id!, wallpaper.isFavourite); 
    
    refreshFavorites();

    if(mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${wallpaper.imageName} removed from favorites.'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final availableWidth = screenWidth - (horizontalMargin * 2);
        
        final numColumns = (availableWidth / (minItemWidth + itemSpacing)).floor();
        final actualColumns = numColumns > 0 ? numColumns : 1; 
        final totalSpacing = itemSpacing * (actualColumns - 1);
        final itemWidth = (availableWidth - totalSpacing) / actualColumns;

        return ResponsiveScaffold(
          title: "Wallpaper Studio",
          onHomePage: false,
          onBrowsePage: false,
          onFavPage: true, 
          onSettingsPage: false,
          body: FutureBuilder(
            future: _fetchFavoritesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }

              // --- Layout for NO WALLPAPERS (Scrollable Empty State) ---
              if (favoriteWallpapers.isEmpty) {
                 return SingleChildScrollView( 
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(horizontalMargin, 50.63, horizontalMargin, 45.94),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, 
                      children: [
                        const TitleDesc(title: "Saved Wallpapers", description: "Your saved wallpapers collection"),
                        const SizedBox(height: 50),
                        
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            // Ensure content takes up at least the remaining vertical space
                            minHeight: constraints.maxHeight - 50.63 - 45.94 - 50 - 80, 
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center, 
                              children: [
                                const Image(image: AssetImage("assets/no_fav.png")),
                                const SizedBox(height: 30,),
                                const Text(
                                  "No Saved Wallpapers",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 24,
                                  ),
                                ),
                                const SizedBox(height: 12,),
                                const Text(
                                  "Start saving your favorite wallpapers to see them here",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 20,),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/browse');
                                  },
                                  // ✅ APPLYING COLOR #FBB03B HERE
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(primaryColor), 
                                  ),
                                  child: const Text(
                                    "Browse Wallpapers",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white, // Ensure text is white for contrast
                                      fontSize: 14,
                                    ),
                                  )
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // --- Layout for WALLPAPERS EXIST (Already Scrollable) ---
              return SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(horizontalMargin, 50.63, horizontalMargin, 45.94),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const TitleDesc(title: "Saved Wallpapers", description: "Your saved wallpapers collection"),
                      const SizedBox(height: 25),
                      
                      Wrap(
                        spacing: itemSpacing,
                        runSpacing: itemSpacing,
                        children: favoriteWallpapers.map((wallpaper) {
                          return SizedBox(
                            width: itemWidth,
                            height: itemWidth / itemAspectRatio, 
                            child: WallpaperButton(
                              wallpaper: wallpaper,
                              showFavourite: true, 
                              onTap: () { /* TODO: Implement navigation */ },
                              onFavoriteToggle: () => _handleFavoriteToggle(wallpaper),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}