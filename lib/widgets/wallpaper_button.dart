import 'dart:ui';
import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/wallpaper_model.dart';
import 'transp_round_button.dart';

class WallpaperButton extends StatefulWidget {
  final Wallpaper wallpaper;
  final bool showFavourite;
  final VoidCallback? onTap;
  // ✅ NEW PARAMETER: Callback to notify the parent when the favorite status changes
  final VoidCallback? onFavoriteToggle; 

  const WallpaperButton({
    super.key,
    required this.wallpaper,
    this.showFavourite = true,
    this.onTap,
    this.onFavoriteToggle, // ✅ ADDED TO CONSTRUCTOR
  });

  @override
  State<WallpaperButton> createState() => _WallpaperButtonState();
}

class _WallpaperButtonState extends State<WallpaperButton> {
  late bool isFavourite;

  // Use a unique key to differentiate between wallpapers if the widget itself is reused
  // This helps ensure initState is called correctly when the underlying data changes
  @override
  void didUpdateWidget(covariant WallpaperButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Important: Update internal state if the wallpaper object itself changes
    if (oldWidget.wallpaper.isFavourite != widget.wallpaper.isFavourite) {
      isFavourite = widget.wallpaper.isFavourite;
    }
  }

  @override
  void initState() {
    super.initState();
    isFavourite = widget.wallpaper.isFavourite;
  }

  Future<void> _toggleFavourite() async {
    // 1. Update the database
    await DatabaseHelper.instance.toggleFavourite(widget.wallpaper.id!, isFavourite);
    
    // 2. Update the internal state for the icon change
    setState(() {
      isFavourite = !isFavourite;
    });

    // 3. ✅ Notify the parent (like FavouritesScreen) to refresh its list
    if (widget.onFavoriteToggle != null) {
      widget.onFavoriteToggle!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Wallpaper image (unchanged)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                image: DecorationImage(
                  image: AssetImage(widget.wallpaper.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Gradient overlay (unchanged)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            // ❤️ Favourite button (glass circle)
            if (widget.showFavourite)
              Positioned(
                top: 8,
                right: 8,
                child: ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: InkWell(
                      // ✅ CALL THE INTERNAL TOGGLE METHOD
                      onTap: _toggleFavourite, 
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isFavourite ?
                            Colors.white
                          : Colors.white.withOpacity(0.25),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.35),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          isFavourite ? Icons.favorite : Icons.favorite_border,
                          color: isFavourite
                              ? Color(0xffFBB03B)
                              : Colors.white.withOpacity(0.85),
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // Name + category glass tag (unchanged)
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.wallpaper.imageName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Assuming TranspRoundButton is a defined widget
                  TranspRoundButton(title: widget.wallpaper.category),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}