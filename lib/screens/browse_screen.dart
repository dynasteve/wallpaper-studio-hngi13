import 'package:flutter/material.dart';
import 'package:hngi13_stage3_wallpaperstudio/widgets/title_desc.dart';
import 'package:hngi13_stage3_wallpaperstudio/widgets/category_card.dart';
import 'package:hngi13_stage3_wallpaperstudio/widgets/category_card_list.dart';
import 'package:hngi13_stage3_wallpaperstudio/db/database_helper.dart'; 
import 'package:hngi13_stage3_wallpaperstudio/models/wallpaper_model.dart'; 
import 'package:sqflite/sqflite.dart';
import 'package:hngi13_stage3_wallpaperstudio/widgets/responsive_scaffold.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  bool isGridView = true;
  Map<String, int> categoryCounts = {};
  late Future<void> _fetchCountsFuture;

  static const double horizontalMargin = 47.0;
  static const double gridSpacing = 20.0;
  static const double headerBreakpoint = 600.0; 

  final List<Map<String, String>> categories = [
    {"image": "assets/images/nature_card.jpg", "label": "Nature", "desc": "Mountains, Forests and Landscapes"},
    {"image": "assets/images/abstract_card.jpg", "label": "Abstract", "desc": "Modern geometric and artistic designs"},
    {"image": "assets/images/urban_card.jpg", "label": "Urban", "desc": "Cities, architecture and street"},
    {"image": "assets/images/space_card.jpg", "label": "Space", "desc": "Cosmos, planets, and galaxies"},
    {"image": "assets/images/minimalist_card.jpg", "label": "Minimalist", "desc": "Clean, simple, and elegant"},
    {"image": "assets/images/animal_card.jpg", "label": "Animal", "desc": "Wildlife and nature photography"},
  ];

  @override
  void initState() {
    super.initState();
    _fetchCountsFuture = _fetchCategoryCounts();
  }
  
  Future<void> _fetchCategoryCounts() async {
    try {
      final Database db = await DatabaseHelper.instance.database;
      
      final Map<String, int> counts = {};
      for (var category in categories) {
        final categoryName = category["label"]!;
        final count = await Wallpaper.getCountByCategory(db, categoryName);
        counts[categoryName] = count;
      }

      if (mounted) {
        setState(() {
          categoryCounts = counts;
        });
      }
    } catch (e) {
      print("Error fetching category counts: $e");
    }
  }

  // Helper method for navigation logic
  void _navigateToCategory(String categoryLabel) {
    Navigator.pushNamed(
      context, 
      '/category_setup', // The route name defined in main.dart
      arguments: categoryLabel // The required argument for WallpaperSetup
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // ✅ RESPONSIVE GRID BREAKPOINTS (3 → 2 → 1)
    int columns;
    if (screenWidth >= 1000) {
      columns = 3;
    } else if (screenWidth >= 650) {
      columns = 2;
    } else {
      columns = 1;
    }

    final totalMargin = horizontalMargin * 2;
    final totalSpacing = gridSpacing * (columns - 1);
    final availableWidth = screenWidth - totalMargin - totalSpacing;
    final cardWidth = availableWidth / columns;

    // Toggle Buttons Widget
    final toggleButtons = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => setState(() => isGridView = true),
          icon: Icon(
            Icons.grid_view_outlined,
            color: isGridView ? const Color.fromARGB(255, 255, 168, 33) : Colors.grey.shade300,
            size: 29.94,
          ),
        ),
        IconButton(
          onPressed: () => setState(() => isGridView = false),
          icon: Icon(
            Icons.view_agenda_outlined, 
            color: !isGridView ? const Color.fromARGB(255, 255, 168, 33) : Colors.grey[300],
            size: 29.94,
          ),
        ),
      ],
    );

    return ResponsiveScaffold(
      title: "Wallpaper Studio",
      onHomePage: false,
      onBrowsePage: true,
      onFavPage: false,
      onSettingsPage: false,
      body: FutureBuilder(
        future: _fetchCountsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
            
          return SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.fromLTRB(horizontalMargin, 52.63, horizontalMargin, 70.94),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  // Header with responsive layout
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > headerBreakpoint) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Expanded(
                              child: TitleDesc(
                                title: "Browse Categories",
                                description: "Explore our curated collections of stunning wallpapers",
                              ),
                            ),
                            toggleButtons,
                          ],
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TitleDesc(
                              title: "Browse Categories",
                              description: "Explore our curated collections of stunning wallpapers",
                            ),
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.centerRight,
                              child: toggleButtons,
                            ),
                          ],
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 50),

                  // ✅ GRID VIEW (CategoryCard)
                  if (isGridView)
                    Wrap(
                      spacing: gridSpacing,
                      runSpacing: gridSpacing,
                      children: categories.map((c) {
                        final categoryLabel = c["label"]!;
                        return SizedBox(
                          width: cardWidth,
                          child: CategoryCard(
                            imagePath: c["image"]!,
                            label: categoryLabel,
                            description: c["desc"]!,
                            imageNumber: categoryCounts[categoryLabel] ?? 0,
                            // 🎯 NAVIGATION: Call the helper function on press
                            onPressed: () => _navigateToCategory(categoryLabel),
                          ),
                        );
                      }).toList(),
                    )

                  // ✅ LIST VIEW (CategoryCardList)
                  else
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        ...categories.map(
                          (c) {
                            final categoryLabel = c["label"]!;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: CategoryCardList(
                                imagePath: c["image"]!,
                                label: categoryLabel,
                                description: c["desc"]!,
                                imageNumber: categoryCounts[categoryLabel] ?? 0,
                                // 🎯 NAVIGATION: Call the helper function on press
                                onPressed: () => _navigateToCategory(categoryLabel),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}