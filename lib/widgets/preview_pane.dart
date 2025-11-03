import 'dart:io';
import 'package:flutter/material.dart';
import '../models/wallpaper_model.dart';

class PreviewPane extends StatelessWidget {
  final Wallpaper wallpaper;
  final VoidCallback? onFavourite;
  final VoidCallback? onSetWallpaper;

  const PreviewPane({
    super.key,
    required this.wallpaper,
    this.onFavourite,
    this.onSetWallpaper,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ----------------- TOP MAIN CONTAINER -----------------
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------- LEFT SIDE: TEXT & DETAILS ----------------
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Preview",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        "Name",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        wallpaper.imageName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        "Tags",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: (wallpaper.tags?.isNotEmpty == true
                                ? wallpaper.tags!
                                : ["No Tags"])
                            .map((t) => TagChip(label: t))
                            .toList(),
                      ),
                      const SizedBox(height: 25),

                      const Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        wallpaper.description?.isNotEmpty == true
                            ? wallpaper.description!
                            : "No description available.",
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Action icons
                      Row(
                        children: [
                          _actionIcon(Icons.upload),
                          const SizedBox(width: 15),
                          _actionIcon(Icons.share),
                          const SizedBox(width: 15),
                          _actionIcon(Icons.settings),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ---------------- RIGHT SIDE: PHONE PREVIEW ----------------
              Expanded(
                flex: 1,
                child: Center(
                  child: SizedBox(
                    width: 250,
                    height: 500,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Wallpaper inside phone screen
                        Positioned(
                          top: 48,
                          left: 22,
                          right: 22,
                          bottom: 48,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: Builder(
                              builder: (context) {
                                final path = wallpaper.imagePath;
                                if (path.startsWith('assets/')) {
                                  return Image.asset(path, fit: BoxFit.cover);
                                } else {
                                  return Image.file(File(path),
                                      fit: BoxFit.cover);
                                }
                              },
                            ),
                          ),
                        ),

                        // Phone frame image
                        Image.asset(
                          'assets/iphone.png',
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // ----------------- BOTTOM ACTION BUTTONS -----------------
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton.icon(
              onPressed: onFavourite,
              icon: const Icon(Icons.favorite_border),
              label: const Text("Save to Favorites"),
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                side: const BorderSide(color: Color(0xFFFFA821)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: onSetWallpaper,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFA821),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Set to Wallpaper",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ----------------- ICON BUTTON BUILDER -----------------
  Widget _actionIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 20),
    );
  }
}

// ----------------- TAG CHIP -----------------
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
