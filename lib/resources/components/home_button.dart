import 'package:flutter/material.dart';
import 'package:healty_ways/resources/app_colors.dart';

class HomeButton extends StatelessWidget {
  final String title;
  final Function onTap;
  final Color color;

  HomeButton({
    super.key,
    required this.title,
    required this.onTap,
    this.color = AppColors.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap(),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        height: 100,
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
