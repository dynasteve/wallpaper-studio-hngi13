import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/wallpaper_model.dart';
import 'transp_round_button.dart';

class WallpaperButton extends StatefulWidget {
  final Wallpaper wallpaper;
  final bool showFavourite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;

  const WallpaperButton({
    super.key,
    required this.wallpaper,
    this.showFavourite = true,
    this.onTap,
    this.onFavoriteToggle,
  });

  @override
  State<WallpaperButton> createState() => _WallpaperButtonState();
}

class _WallpaperButtonState extends State<WallpaperButton> {
  late bool isFavourite;

  @override
  void initState() {
    super.initState();
    isFavourite = widget.wallpaper.isFavourite;
  }

  @override
  void didUpdateWidget(covariant WallpaperButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.wallpaper.isFavourite != widget.wallpaper.isFavourite) {
      isFavourite = widget.wallpaper.isFavourite;
    }
  }

  Future<void> _toggleFavourite() async {
    await DatabaseHelper.instance.toggleFavourite(widget.wallpaper.id!, isFavourite);
    setState(() {
      isFavourite = !isFavourite;
    });
    if (widget.onFavoriteToggle != null) {
      widget.onFavoriteToggle!();
    }
  }

  /// ✅ Determines whether to use FileImage or AssetImage dynamically
  ImageProvider _getImageProvider(String path) {
    try {
      if (path.startsWith('/') || path.contains('storage')) {
        final file = File(path);
        if (file.existsSync()) {
          return FileImage(file);
        }
      }
      // Default to asset if not a valid file
      return AssetImage(path);
    } catch (e) {
      // fallback placeholder
      return const AssetImage('assets/images/placeholder.jpg');
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
            // ✅ Wallpaper image (works for both asset and file)
            Container(
              width: 220,
              height: 320,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.grey[300],
                image: DecorationImage(
                  image: _getImageProvider(widget.wallpaper.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Gradient overlay
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

            // ❤️ Favourite button
            if (widget.showFavourite)
              Positioned(
                top: 8,
                right: 8,
                child: ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: InkWell(
                      onTap: _toggleFavourite,
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isFavourite
                              ? Colors.white
                              : Colors.white.withOpacity(0.25),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.35),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          isFavourite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: isFavourite
                              ? const Color(0xffFBB03B)
                              : Colors.white.withOpacity(0.85),
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // Name + category glass tag
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
