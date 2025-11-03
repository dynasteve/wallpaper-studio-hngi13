import 'package:flutter/material.dart';
// NOTE: Navbar is imported but not used in the widget, ResponsiveScaffold handles nav
import 'package:hngi13_stage3_wallpaperstudio/db/database_helper.dart';
import 'package:hngi13_stage3_wallpaperstudio/models/wallpaper_model.dart';
import 'package:hngi13_stage3_wallpaperstudio/widgets/wallpaper_button.dart';
import 'package:hngi13_stage3_wallpaperstudio/widgets/wallpaper_preview_pane.dart';
import 'package:hngi13_stage3_wallpaperstudio/widgets/responsive_scaffold.dart';

class WallpaperSetup extends StatefulWidget {
  final String category;

  const WallpaperSetup({
    super.key,
    required this.category,
  });

  @override
  State<WallpaperSetup> createState() => _WallpaperSetupState();
}

class _WallpaperSetupState extends State<WallpaperSetup> {
  List<Wallpaper> wallpapers = [];
  Wallpaper? selectedWallpaper;
  bool isGridView = true;

  // Define breakpoint for switching to vertical layout
  static const double splitViewBreakpoint = 800.0;

  @override
  void initState() {
    super.initState();
    _loadWallpapers();
  }

  // --- Data Loading and Selection ---

  Future<void> _loadWallpapers() async {
    final dbWallpapers =
        await DatabaseHelper.instance.getWallpapersByCategory(widget.category);
    setState(() {
      wallpapers = dbWallpapers;
      // Set the first item as selected if the list isn't empty
      if (wallpapers.isNotEmpty) {
        selectedWallpaper = wallpapers.first;
      }
    });
  }

  void _selectWallpaper(Wallpaper wallpaper) {
    setState(() {
      selectedWallpaper = wallpaper;
    });
  }

  // --- Favorite Toggle Logic ---

  void _toggleFavoriteStatus(Wallpaper wallpaper) async {
    // 1. Get the current favorite status (handled internally by WallpaperButton's state)
    // 2. Call the DB toggle (handled internally by WallpaperButton's state)

    // 3. ✅ Refresh the current list to update the Wallpaper object in the list
    // This is crucial if we display the favorite status here or if the list is used elsewhere.
    await _loadWallpapers(); 

    // 4. Update the selectedWallpaper to reflect the new favorite status
    // Find the wallpaper in the newly loaded list and set it as selected
    final newSelected = wallpapers.firstWhere(
      (w) => w.id == wallpaper.id,
      orElse: () => wallpaper, // Fallback if somehow not found
    );

    setState(() {
      selectedWallpaper = newSelected;
    });
  }

  // --- Building the Wallpaper Grid/List ---

  Widget _buildWallpaperList(double screenWidth) {
    // Grid settings
    final crossAxisCount = screenWidth >= 1000 ? 3 : screenWidth >= 650 ? 2 : 1;
    final childAspectRatio = crossAxisCount == 1 ? 16 / 9 : 9 / 14;

    if (wallpapers.isEmpty) {
      return const Center(child: Text("No wallpapers found"));
    }

    // Grid View
    if (isGridView && crossAxisCount > 1) {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: childAspectRatio,
        ),
        itemCount: wallpapers.length,
        itemBuilder: (context, index) {
          final wallpaper = wallpapers[index];
          return WallpaperButton(
            wallpaper: wallpaper,
            showFavourite: true,
            onTap: () => _selectWallpaper(wallpaper),
            // ✅ PASS THE FAVORITE TOGGLE HANDLER
            onFavoriteToggle: () => _toggleFavoriteStatus(wallpaper),
          );
        },
      );
    }
    
    // List View (or single column on small screens)
    return ListView.builder(
      itemCount: wallpapers.length,
      itemBuilder: (context, index) {
        final wallpaper = wallpapers[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: WallpaperButton(
            wallpaper: wallpaper,
            showFavourite: true,
            onTap: () => _selectWallpaper(wallpaper),
            // ✅ PASS THE FAVORITE TOGGLE HANDLER
            onFavoriteToggle: () => _toggleFavoriteStatus(wallpaper),
          ),
        );
      },
    );
  }

  // --- Main Build Method ---

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSplitView = screenWidth >= splitViewBreakpoint;

    // The entire body content, adjusted for responsiveness
    Widget content = Padding(
      padding: EdgeInsets.fromLTRB(47, 40, isSplitView ? 20 : 47, 16.57),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
              ),
              const Text("Back to Categories"),
            ],
          ),
          const SizedBox(height: 13),
          
          // Category Title and View Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.category,
                style: const TextStyle(
                  fontFamily: "ClashDisplay",
                  fontWeight: FontWeight.w400,
                  fontSize: 48,
                ),
              ),
              if (isSplitView) // Only show toggle buttons in split view
                Row(
                  children: [
                    IconButton(
                      onPressed: () => setState(() => isGridView = true),
                      icon: Icon(
                        Icons.grid_view_outlined,
                        color: isGridView ? const Color.fromARGB(255, 255, 168, 33) : Colors.grey.shade300,
                        size: 30,
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => isGridView = false),
                      icon: Icon(
                        Icons.view_agenda_outlined,
                        color: !isGridView ? const Color.fromARGB(255, 255, 168, 33) : Colors.grey.shade300,
                        size: 30,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Wallpaper List/Grid Area
          Expanded(
            child: _buildWallpaperList(screenWidth),
          ),
        ],
      ),
    );

    // If screen is wide enough, use the side-by-side split view
    if (isSplitView) {
      return ResponsiveScaffold(
        title: "Wallpaper Studio",
        onHomePage: false, // Update these flags as needed
        onBrowsePage: false,
        onFavPage: false,
        onSettingsPage: false,
        body: Row(
          children: [
            // LEFT SIDE - Wallpaper Grid/List
            Expanded(
              flex: 3,
              child: content,
            ),
            // RIGHT SIDE - Gradient + Preview
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 40, 47, 16.57),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.white, Color(0xFFF5F5F5)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: selectedWallpaper == null
                      ? const Center(
                          child: Text(
                            "Select a wallpaper to preview",
                            style: TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                        )
                      : WallpaperPreviewPane(wallpaper: selectedWallpaper!),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // For smaller screens (Mobile/Tablet), only show the list/grid content
    return ResponsiveScaffold(
      title: "Wallpaper Studio",
      onHomePage: false,
      onBrowsePage: false,
      onFavPage: false,
      onSettingsPage: false,
      // Wrap content in a SingleChildScrollView for small screens
      body: SingleChildScrollView(child: content),
    );
  }
}