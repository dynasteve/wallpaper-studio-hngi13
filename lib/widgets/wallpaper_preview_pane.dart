import 'dart:io';
import 'package:flutter/material.dart';
import '../models/wallpaper_model.dart';

class WallpaperPreviewPane extends StatelessWidget {
  final Wallpaper wallpaper;
  final VoidCallback? onSetWallpaper;
  final VoidCallback? onToggleFavourite;

  const WallpaperPreviewPane({
    super.key,
    required this.wallpaper,
    this.onSetWallpaper,
    this.onToggleFavourite,
  });

  @override
  Widget build(BuildContext context) {
    // Safely extract tags
    final List<String> tags = (wallpaper.tags != null && wallpaper.tags is List)
        ? List<String>.from(wallpaper.tags!)
        : <String>[];

    // Safely extract description
    final String description =
        (wallpaper.description != null &&
                wallpaper.description!.trim().isNotEmpty)
            ? wallpaper.description!
            : "No description available for this wallpaper.";

    // ===============================================
    // ✅ DYNAMIC FAVOURITE LOGIC
    // ===============================================
    final bool isFavourite = wallpaper.isFavourite;
    final String favLabel = isFavourite ? "Remove from Favourites" : "Save to Favourites";
    final IconData favIcon = isFavourite ? Icons.favorite : Icons.favorite_border;
    
    // Use the primary color (0xffFBB03B) for the filled state
    final Color favColor = isFavourite ? const Color(0xffFBB03B) : Colors.grey.shade200; 
    
    // Text is white when filled, black when outlined
    final Color favTextColor = isFavourite ? Colors.white : Colors.black;
    
    // Only use the outlined style when it is NOT a favourite
    final bool favOutlined = !isFavourite; 
    // ===============================================


    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // LEFT PANEL
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Preview",
                          style: TextStyle(
                            fontSize: 32,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Name",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Poppins",
                            color: Color(0xff808080),
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          wallpaper.imageName ?? "Untitled",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 20),

                        const Text(
                          "Tags",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Poppins",
                            color: Color(0xff808080),
                          ),
                        ),
                        const SizedBox(height: 1),
                        Wrap(
                          spacing: 8,
                          children: tags.isNotEmpty
                              ? tags.map((tag) => TagChip(label: tag)).toList()
                              : [const TagChip(label: "No Tags")],
                        ),
                        const SizedBox(height: 25),

                        const Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Poppins",
                            color: Color(0xff808080),
                          ),
                        ),
                        const SizedBox(height: 1),

                        // Scrollable description
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              description,
                              style: const TextStyle(fontSize: 14, height: 1.4),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // 3 square icon
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _actionIcon(Icons.ios_share_rounded),
                            const SizedBox(width: 15),
                            _actionIcon(Icons.south_east_outlined),
                            const SizedBox(width: 15),
                            _actionIcon(Icons.settings_outlined),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // RIGHT PHONE PREVIEW
                Expanded(
                  flex: 1,
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 9 / 16,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: 5,
                            left: 18,
                            right: 18,
                            bottom: 5,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: _buildPreviewImage(wallpaper),
                            ),
                          ),
                          Image.asset('assets/iphone.png', fit: BoxFit.contain), // 
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // TWO ACTION BUTTONS BELOW
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Favourites Button (DYNAMIC)
                _mainButton(
                  // ✅ Using dynamic properties
                  label: favLabel, 
                  icon: favIcon,
                  color: favColor, 
                  textColor: favTextColor,
                  borderColor: Colors.grey.shade400, // Fixed border color for outlined state
                  outlined: favOutlined,
                  onPressed: onToggleFavourite,
                ),
                const SizedBox(width: 20),
                // Set as Wallpaper Button (Filled)
                _mainButton(
                  label: "Set as Wallpaper",
                  color: const Color(0xffFBB03B), 
                  textColor: Colors.white, 
                  onPressed: onSetWallpaper,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets ---

  // ... (All helper widgets remain the same)
  Widget _buildPreviewImage(Wallpaper wallpaper) {
    final path = wallpaper.imagePath;

    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Center(child: Text("Image not found")),
      );
    } else {
      final file = File(path);
      if (file.existsSync()) {
        return Image.file(file, fit: BoxFit.cover);
      } else {
        return const Center(child: Text("File not found"));
      }
    }
  }

  Widget _actionIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border.all(color: Color(0xffe5e5e5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 20, color: Color(0xff808080),),
    ),
    );
  }

  Widget _mainButton({
    required String label,
    IconData? icon,
    required Color color, 
    VoidCallback? onPressed,
    Color? textColor, 
    Color? borderColor,
    bool outlined = false,
  }) {
    final resolvedTextColor = textColor ?? (outlined ? Colors.black : Colors.white);

    if (outlined) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: resolvedTextColor, 
          side: BorderSide(
            color: borderColor ?? Colors.grey.shade400,
            width: 1.5,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        icon: Icon(icon),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    } else {
      return ElevatedButton.icon(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(color),
          foregroundColor: MaterialStateProperty.all<Color>(resolvedTextColor),
          elevation: MaterialStateProperty.all<double>(2),
          padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ),
        icon: icon != null ? Icon(icon) : null, // Added check for icon
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
  }
}

class TagChip extends StatelessWidget {
  final String label;
  const TagChip({required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}