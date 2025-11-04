import 'package:flutter/material.dart';
import 'package:hngi13_stage3_wallpaperstudio/db/database_helper.dart';
import 'package:hngi13_stage3_wallpaperstudio/models/wallpaper_model.dart';
import 'package:hngi13_stage3_wallpaperstudio/widgets/wallpaper_button.dart';
import 'package:hngi13_stage3_wallpaperstudio/widgets/wallpaper_preview_pane.dart';
import 'package:hngi13_stage3_wallpaperstudio/widgets/responsive_scaffold.dart';
import 'package:hngi13_stage3_wallpaperstudio/widgets/wallpaper_setup_sidepanel.dart';

class WallpaperSetup extends StatefulWidget {
  final String category;

  const WallpaperSetup({super.key, required this.category});

  @override
  State<WallpaperSetup> createState() => _WallpaperSetupState();
}

class _WallpaperSetupState extends State<WallpaperSetup> {
  List<Wallpaper> wallpapers = [];
  Wallpaper? selectedWallpaper;
  bool isGridView = true;
  bool showSetWallpaperPanel = false;

  // Define breakpoint for switching to vertical layout
  static const double splitViewBreakpoint = 800.0;
  // Define aspect ratio for the List View item (e.g., a wide rectangle)
  static const double listViewAspectRatio =
      3.5; // Example: 3.5 units wide for every 1 unit high


  @override
  void initState() {
    super.initState();
    _loadWallpapers();
  }

  // --- Data Loading and Selection ---

  Future<void> _loadWallpapers() async {
    final dbWallpapers = await DatabaseHelper.instance.getWallpapersByCategory(
      widget.category,
    );
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
    await _loadWallpapers();

    // Update the selectedWallpaper to reflect the new favorite status
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
    if (wallpapers.isEmpty) {
      return const Center(child: Text("No wallpapers found"));
    }

    final bool useGridView = isGridView && screenWidth >= splitViewBreakpoint;

    // Grid View Logic
    if (useGridView) {
      final crossAxisCount = screenWidth >= 1000 ? 3 : 2;
      const childAspectRatio = 9 / 14;

      return GridView.builder(
        padding: const EdgeInsets.only(
          top: 16,
        ), // Add a little padding to the top of the grid
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
            onFavoriteToggle: () => _toggleFavoriteStatus(wallpaper),
          );
        },
      );
    }

    // List View (or single column on small screens)
    // On small screens, this effectively acts as a single-column grid, but
    // we use a distinct List View appearance for the split view when !isGridView.
    return ListView.builder(
      padding: const EdgeInsets.only(
        top: 16,
      ), // Add a little padding to the top of the list
      itemCount: wallpapers.length,
      itemBuilder: (context, index) {
        final wallpaper = wallpapers[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: AspectRatio(
            // <--- Use AspectRatio for list item shape
            aspectRatio: listViewAspectRatio,
            child: WallpaperButton(
              wallpaper: wallpaper,
              showFavourite: true,
              onTap: () => _selectWallpaper(wallpaper),
              onFavoriteToggle: () => _toggleFavoriteStatus(wallpaper),
            ),
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
          const SizedBox(height: 1),

          // Category Title and View Toggle
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
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
                        color: isGridView
                            ? const Color.fromARGB(255, 255, 168, 33)
                            : Colors.grey.shade300,
                        size: 30,
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => isGridView = false),
                      icon: Icon(
                        Icons.view_agenda_outlined,
                        color: !isGridView
                            ? const Color.fromARGB(255, 255, 168, 33)
                            : Colors.grey.shade300,
                        size: 30,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Wallpaper List/Grid Area
          Expanded(child: _buildWallpaperList(screenWidth)),
        ],
      ),
    );

    // If screen is wide enough, use the side-by-side split view
    if (isSplitView) {
      return ResponsiveScaffold(
        title: "Wallpaper Studio",
        onHomePage: false,
        onBrowsePage: false,
        onFavPage: false,
        onSettingsPage: false,
        body: Stack(
          children: [
            // --- Main content row ---
            Row(
              children: [
                Expanded(flex: 3, child: content),
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
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            )
                          : WallpaperPreviewPane(
                              wallpaper: selectedWallpaper!,
                              onSetWallpaper: () {
                                setState(() => showSetWallpaperPanel = true);
                              },
                              onToggleFavourite: () =>
                                  _toggleFavoriteStatus(selectedWallpaper!),
                            ),
                    ),
                  ),
                ),
              ],
            ),

            // --- Dim background when panel is open ---
            if (showSetWallpaperPanel)
              AnimatedOpacity(
                opacity: 0.4,
                duration: const Duration(milliseconds: 250),
                child: GestureDetector(
                  onTap: () => setState(() => showSetWallpaperPanel = false),
                  child: Container(color: Colors.black),
                ),
              ),

            // --- Right-side drawer panel ---
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              right: showSetWallpaperPanel
                  ? 0
                  : -MediaQuery.of(context).size.width * 0.45,
              top: 0,
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.45,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    bottomLeft: Radius.circular(0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(-3, 0),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Expanded(
                      child: Center(
                        child: WallpaperSetupSidePanel(),
                      ),
                    ),
                  ],
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
      onBrowsePage: true,
      onFavPage: false,
      onSettingsPage: false,
      // Wrap content in a SingleChildScrollView for small screens
      body: SingleChildScrollView(child: content),
    );
  }
}
