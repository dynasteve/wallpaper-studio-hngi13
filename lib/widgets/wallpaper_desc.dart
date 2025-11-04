import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hngi13_stage3_wallpaperstudio/models/wallpaper_model.dart';

class WallpaperDesc extends StatelessWidget {
  final Wallpaper selectedWallpaper;

  const WallpaperDesc({
    super.key,
    required this.selectedWallpaper,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white, // white card background
        border: Border.all(color: const Color(0xFFE5E5E5), width: 1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Wallpaper Image with border
          Container(
            width: 150,
            height: 240,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE0E0E0), width: 5),
              color: Colors.grey[100],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: _buildPreviewImage(selectedWallpaper.imagePath),
            ),
          ),

          const SizedBox(width: 40),

          // ✅ Text and action buttons arranged vertically
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                const GradientText(
                  "Your Active Wallpaper",
                  TextStyle(
                    fontSize: 34,
                    fontFamily: 'ClashDisplay',
                    fontWeight: FontWeight.w500,
                  ),
                  gradient: LinearGradient(
                    colors: [Color(0xFFFBB03B), Color(0xFFEC0C43)],
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: const Text(
                    "This wallpaper is currently set as your active background",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 22,
                      fontFamily: 'Poppins',
                      color: Color(0xFF808080),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    const Text(
                      "Category - ",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        color: Color(0xff808080),
                      ),
                    ),
                    Text(
                      selectedWallpaper.category ?? "Unknown",
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                        color: Color(0xff808080),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "Selection - ",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        color: Color(0xff808080),
                      ),
                    ),
                    Text(
                      selectedWallpaper.imageName ?? "Untitled",
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                        color: Color(0xff808080),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ✅ Bottom-right aligned buttons
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _squareActionButton(
                        icon: Icons.ios_share_rounded,
                        color: Color(0xff7c7c7c),
                        onPressed: () {
                          print("Hello, Share pressed");
                        },
                      ),
                      const SizedBox(width: 10),
                      _squareActionButton(
                        icon: Icons.settings_outlined,
                        color: Color(0xff7c7c7c),
                        onPressed: () {
                          print("Hello, settings pressed");
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Dynamically loads wallpaper from assets or file
  Widget _buildPreviewImage(String path) {
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

  /// Reusable square action button
  Widget _squareActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.35)),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}

/// GradientText (unchanged)
class GradientText extends StatelessWidget {
  const GradientText(
    this.text,
    this.style, {
    super.key,
    required this.gradient,
  });

  final String text;
  final TextStyle style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) =>
          gradient.createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(text, style: style),
    );
  }
}
