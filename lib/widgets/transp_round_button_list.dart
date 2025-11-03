import 'package:flutter/material.dart';

class TranspRoundButton extends StatelessWidget {

  final String title;

  const TranspRoundButton({
    super.key, 
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: null,
      child: Container(
        width: 130,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          // Outer gradient border
          color: Color.fromARGB(142, 86, 86, 86),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
          // Inner semi-transparent background
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 233, 233, 233),
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}