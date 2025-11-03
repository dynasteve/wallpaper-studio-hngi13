import 'package:flutter/material.dart';
import 'package:hngi13_stage3_wallpaperstudio/widgets/title_desc.dart';
import 'package:hngi13_stage3_wallpaperstudio/widgets/category_card.dart';
import 'package:hngi13_stage3_wallpaperstudio/db/database_helper.dart';
import 'package:hngi13_stage3_wallpaperstudio/models/wallpaper_model.dart';
import 'package:hngi13_stage3_wallpaperstudio/widgets/responsive_scaffold.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, int> categoryCounts = {};
  late Future<void> _fetchCountsFuture;

  static const double horizontalMargin = 47.0;
  static const double cardSpacing = 20.0;

  @override
  void initState() {
    super.initState();
    _fetchCountsFuture = _loadCategoryCounts();
  }

  Future<void> _loadCategoryCounts() async {
    final db = await DatabaseHelper.instance.database;

    final List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT DISTINCT category FROM wallpapers');

    final Map<String, int> counts = {};
    await Future.wait(result.map((row) async {
      final category = row['category'] as String;
      final count = await Wallpaper.getCountByCategory(db, category);
      counts[category] = count;
    }));

    if (mounted) {
      setState(() {
        categoryCounts = counts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    int columns;
    if (screenWidth >= 1000) {
      columns = 3;
    } else if (screenWidth >= 650) {
      columns = 2;
    } else {
      columns = 1;
    }

    final availableWidth = screenWidth - (horizontalMargin * 2);
    final totalSpacing = cardSpacing * (columns - 1);
    final cardWidth = (availableWidth - totalSpacing) / columns;

    final allCategories = [
      {"image": "assets/images/nature_card.jpg", "label": "Nature", "desc": "Mountains, Forests and Landscapes"},
      {"image": "assets/images/abstract_card.jpg", "label": "Abstract", "desc": "Modern Geometric and artistic designs"},
      {"image": "assets/images/urban_card.jpg", "label": "Urban", "desc": "Cities, architecture and street"},
      {"image": "assets/images/space_card.jpg", "label": "Space", "desc": "Cosmos, planets, and galaxies"},
      {"image": "assets/images/minimalist_card.jpg", "label": "Minimalist", "desc": "Clean, simple, and elegant"},
      {"image": "assets/images/animal_card.jpg", "label": "Animal", "desc": "Wildlife and nature photography"},
    ];

    return ResponsiveScaffold(
      title: "Wallpaper Studio",
      onHomePage: true,
      onBrowsePage: false,
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
              alignment: Alignment.center,
              margin: const EdgeInsets.fromLTRB(horizontalMargin, 50.63, horizontalMargin, 45.94),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TitleDesc(
                    title: "Discover Beautiful Wallpapers",
                    description:
                        "Discover curated collections of stunning wallpapers. Browse by category, preview in full-screen, and set your favorites.",
                  ),
                  const SizedBox(height: 50),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Categories",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 32,
                          fontFamily: "Poppins",
                        ),
                      ),
                      TextButton(
                        // 🎯 NAVIGATION: Go to the general browse screen
                        onPressed: () {
                          Navigator.pushNamed(context, '/browse');
                        },
                        child: const Text(
                          "See All",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff808080),
                            fontFamily: "Poppins",
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Wrap(
                    spacing: cardSpacing,
                    runSpacing: 23,
                    children: allCategories.map((c) {
                      final categoryLabel = c["label"]!;
                      return SizedBox(
                        width: cardWidth,
                        child: CategoryCard(
                          imagePath: c["image"]!,
                          label: categoryLabel,
                          description: c["desc"]!,
                          imageNumber: categoryCounts[categoryLabel] ?? 0,
                          onPressed: () {
                            // 🎯 NAVIGATION: Go to the WallpaperSetup screen for the specific category
                            Navigator.pushNamed(
                              context, 
                              '/category_setup', 
                              arguments: categoryLabel // Pass the category name as an argument
                            );
                          },
                        ),
                      );
                    }).toList(),
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