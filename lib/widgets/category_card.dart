import 'package:flutter/material.dart';
import 'package:hngi13_stage3_wallpaperstudio/widgets/transp_round_button.dart';


class CategoryCard extends StatelessWidget {

  final String imagePath;
  final String label;
  final String description;
  final VoidCallback onPressed;
  final int imageNumber;

  const CategoryCard({
    super.key,
    required this.imagePath,
    required this.label,
    required this.onPressed, 
    required this.description, 
    required this.imageNumber,
  });

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 270,
        width: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          alignment: Alignment.bottomLeft,
          padding: EdgeInsets.fromLTRB(25, 0, 0, 18.71),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            color: const Color.fromARGB(255, 73, 57, 57).withOpacity(0.25),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TranspRoundButton(title: "$imageNumber wallpapers")
            ],
          ),
        ),
      ),
    );
  }
}