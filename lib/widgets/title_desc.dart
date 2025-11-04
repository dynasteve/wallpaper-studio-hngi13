import 'package:flutter/material.dart';

class TitleDesc extends StatelessWidget {

  final String title;
  final String description;

  const TitleDesc({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            title,
            TextStyle(
              fontSize: 60,
              fontFamily: 'ClashDisplay',
              fontWeight: FontWeight.w500,
            ),
            gradient: LinearGradient(colors: [
              Color(0xFFFBB03B),
              Color(0xFFEC0C43),
            ])
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Text(
              description,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 24,
                fontFamily: 'Poppins',
                color: Color(0xFF575757)
              ),
            ),
          )
        ],
      ),
    );
  }
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text,
    this.style,
    {
    super.key, 
    required this.gradient,
  });

  final String text;
  final TextStyle style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text, 
        style: style
      ),
    );
  }
}