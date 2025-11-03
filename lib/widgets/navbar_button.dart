import 'package:flutter/material.dart';

class NavbarButton extends StatelessWidget {
  final String title;
  final AssetImage image;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool onPage;
  // ✅ 1. NEW PROPERTY: Flag to indicate if the button is in the drawer
  final bool isDrawer;

  const NavbarButton({
    super.key,
    required this.title,
    this.backgroundColor,
    this.foregroundColor,
    this.onPressed,
    required this.onPage, 
    required this.image,
    this.isDrawer = false, // ✅ 2. Default to false (for AppBar use)
  });

  @override
  Widget build(BuildContext context) {
    // Determine horizontal padding based on location
    final double horizontalPadding = isDrawer ? 20.0 : 10.0;
    
    return ElevatedButton(
      onPressed: onPressed ?? () {},
      style: ElevatedButton.styleFrom(
        // Use full width in the drawer, otherwise min-width
        minimumSize: isDrawer ? const Size(double.infinity, 50) : Size.zero, 
        
        backgroundColor: onPage
            ? (backgroundColor ?? Colors.grey[200])
            : Colors.transparent,
        foregroundColor: onPage
            ? (foregroundColor ?? Colors.black)
            : Colors.grey[500],
        elevation: onPage ? 2 : 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        // 3. Adjust padding for wider touch target in the Drawer
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 10),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Row(
          // ✅ 4. Use start alignment in the Drawer for the list style
          mainAxisAlignment: isDrawer ? MainAxisAlignment.start : MainAxisAlignment.center,
          mainAxisSize: isDrawer ? MainAxisSize.max : MainAxisSize.min, // Take full width in drawer
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              child: Image(
                colorBlendMode: BlendMode.srcIn,
                color: onPage
                    ? (foregroundColor ?? Colors.black)
                    : Colors.grey[500],
                image: image,
              ),
            ),
            const SizedBox(width: 10), // Increased spacing for readability in the list
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}