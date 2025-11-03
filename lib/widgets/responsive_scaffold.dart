// File: lib/widgets/responsive_scaffold.dart (FINAL UPDATE)

import 'package:flutter/material.dart';
import 'package:hngi13_stage3_wallpaperstudio/widgets/navbar.dart'; 
import 'package:hngi13_stage3_wallpaperstudio/widgets/navbar_button.dart'; 

// Define the breakpoint
const double kTabletBreakpoint = 800.0;

class ResponsiveScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;
  
  final bool onHomePage;
  final bool onBrowsePage;
  final bool onFavPage;
  final bool onSettingsPage;

  const ResponsiveScaffold({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
    required this.onHomePage,
    required this.onBrowsePage,
    required this.onFavPage,
    required this.onSettingsPage,
  });

  // Helper function to map button title to named route
  String _getRouteName(String title) {
    switch (title) {
      case 'Home':
        return '/';
      case 'Browse':
        return '/browse';
      case 'Favourites':
        return '/favourites';
      case 'Settings':
        // NOTE: Use the placeholder name. Ensure this route is defined in main.dart
        return '/settings'; 
      default:
        return '/'; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth >= kTabletBreakpoint;

        return Scaffold(
          // Use endDrawer for right-side placement
          endDrawer: isWideScreen ? null : _buildDrawer(context),
          
          appBar: AppBar(
            toolbarHeight: 90,
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            elevation: 0,
            shadowColor: Colors.black,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            
            automaticallyImplyLeading: false, 
            
            title: NavBar(
              isWideScreen: isWideScreen, 
              onHomePage: onHomePage,
              onBrowsePage: onBrowsePage,
              onFavPage: onFavPage,
              onSettingsPage: onSettingsPage,
            ),
            centerTitle: true,
            
            // Add actions to place the menu icon on the right for narrow screens
            actions: [
              if (!isWideScreen)
                Builder(
                  builder: (context) {
                    return IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openEndDrawer(), 
                      tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                    );
                  },
                ),
              const SizedBox(width: 16),
            ],
            
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(color: Colors.grey[400], height: 1.0),
            ),
          ),
          body: body,
          floatingActionButton: floatingActionButton,
        );
      },
    );
  }

  // Helper function to build the simplified Drawer content
  Widget _buildDrawer(BuildContext context) {
    // Define the navigation items
    final List<Map<String, dynamic>> navItems = [
      {
        'title': 'Home', 
        'onPage': onHomePage, 
        'image': const AssetImage("assets/vectors/home.png")
      },
      {
        'title': 'Browse', 
        'onPage': onBrowsePage, 
        'image': const AssetImage("assets/vectors/grid.png")
      },
      {
        'title': 'Favourites', 
        'onPage': onFavPage, 
        'image': const AssetImage("assets/vectors/fav.png")
      },
      {
        'title': 'Settings', 
        'onPage': onSettingsPage, 
        'image': const AssetImage("assets/vectors/settings.png")
      },
    ];

    return Drawer(
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 40.0), // Padding from the top of the screen
        itemCount: navItems.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = navItems[index];
          final routeName = _getRouteName(item['title']);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: NavbarButton(
              title: item['title'],
              image: item['image'],
              onPage: item['onPage'],
              onPressed: () {
                // 1. Close the drawer first
                Navigator.pop(context); 
                
                // 2. 🎯 Navigate using the corresponding named route
                // If the user is already on the page, don't navigate
                if (!item['onPage']) {
                    Navigator.pushNamed(context, routeName);
                }
              },
              isDrawer: true, 
            ),
          );
        },
      ),
    );
  }
}