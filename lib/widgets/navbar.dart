// File: lib/widgets/navbar.dart

import 'package:flutter/material.dart';
import 'navbar_button.dart';

class NavBar extends StatelessWidget {

  final bool isWideScreen;
  
  final bool onHomePage;
  final bool onBrowsePage;
  final bool onFavPage;
  final bool onSettingsPage;

  const NavBar(
    {
    super.key, 
    required this.isWideScreen,
    required this.onHomePage, 
    required this.onBrowsePage, 
    required this.onFavPage, 
    required this.onSettingsPage, 
  }
  );

  // Define button spacing
  static const double buttonSpacing = 12.0;
  
  // Extracted Logo/Title Widget (used in both wide and narrow)
  Widget _buildLogo() {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image(
          image: AssetImage("assets/logo.png"),
          width: 14,
          height: 14,
        ),
        SizedBox(width: 8,),
        Text(
          "Wallpaper Studio",
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        )
      ],
    );
  }

  // Extracted Navigation Buttons Widget (only used on wide screen)
  Widget _buildNavButtons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        NavbarButton(
          title: 'Home',
          image: const AssetImage("assets/vectors/home.png"),
          onPage: onHomePage,
          // 🎯 NAVIGATION: Go to the main Home screen
          onPressed: () { 
            Navigator.pushNamed(context, '/'); 
          },
        ),
        const SizedBox(width: buttonSpacing),
        NavbarButton(
          title: 'Browse',
          image: const AssetImage("assets/vectors/grid.png"),
          onPage: onBrowsePage,
          // 🎯 NAVIGATION: Go to the Browse screen
          onPressed: () { 
            Navigator.pushNamed(context, '/browse'); 
          },
        ),
        const SizedBox(width: buttonSpacing),
        NavbarButton(
          title: 'Favourites',
          image: const AssetImage("assets/vectors/fav.png"),
          onPage: onFavPage,
          // 🎯 NAVIGATION: Go to the Favourites screen
          onPressed: () { 
            Navigator.pushNamed(context, '/favourites'); 
          },
        ),
        const SizedBox(width: buttonSpacing),
        NavbarButton(
          title: 'Settings',
          image: const AssetImage("assets/vectors/settings.png"),
          onPage: onSettingsPage,
          // NOTE: Assuming you will create a '/settings' route later
          onPressed: () { 
              Navigator.pushNamed(context, '/settings');
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(content: Text('Settings navigation not yet implemented.')),
            // );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Keep your margins
      margin: const EdgeInsets.fromLTRB(47, 0, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // The logo is always shown
          _buildLogo(),
          
          // Only show the buttons if it's a wide screen
          if (isWideScreen) _buildNavButtons(context),
        ],
      ),
    );
  }
}