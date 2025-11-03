import 'package:flutter/material.dart';
import 'package:hngi13_stage3_wallpaperstudio/widgets/transp_round_button_list.dart'; 

class CategoryCardList extends StatelessWidget {
  final String imagePath;
  final String label;
  final String description;
  final VoidCallback onPressed;
  // ✅ FIX 1: Add the missing imageNumber parameter
  final int imageNumber; 

  const CategoryCardList({
    super.key,
    required this.imagePath,
    required this.label,
    required this.onPressed, 
    required this.description,
    // ✅ FIX 1: Add it to the constructor
    required this.imageNumber, 
  });

  @override
  Widget build(BuildContext context) {
    // ⚠️ NOTE: The original code was using a custom Column/Row that seems non-standard
    // (using 'spacing' property). I've converted this to standard Flutter widgets
    // using a regular Column and SizedBox for spacing between the item and the divider.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Image Container
            GestureDetector(
              onTap: onPressed,
              child: Container(
                // Preserving the original fixed sizes
                height: 185.12,
                width: 277.21,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            
            // Text and Button Content
            Expanded( // Use Expanded to ensure this part takes available space
              child: Container(
                // Removed fixed alignment/padding to make it easier to position
                // The Padding below will handle the spacing relative to the image
                padding: const EdgeInsets.only(left: 25.0, bottom: 18.71),
                alignment: Alignment.bottomLeft,
                // Removed the unnecessary BoxDecoration, as it had no visible properties
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 12), // Spacing before the button
                    // ✅ FIX 2: Use the dynamic imageNumber in the button title
                    TranspRoundButton(title: "$imageNumber wallpapers"), 
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20), // Spacing between the card and the divider
        const Divider(),
      ],
    );
  }
}