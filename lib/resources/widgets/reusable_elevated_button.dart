import 'package:flutter/material.dart';
import '../../utils/app_urls.dart';

class ReuseableElevatedbutton extends StatelessWidget {
  const ReuseableElevatedbutton({
    super.key,
    required this.buttonName,
    this.onPressed,
    this.width = double.infinity,
    this.color = AppColors.primaryColor,
    this.margin,
    this.textColor = Colors.white,
    this.padding,
    this.borderColor,
    this.isLoading = false,
  });

  final String buttonName;
  final VoidCallback? onPressed;
  final double width;
  final Color color;
  final Color? borderColor;
  final EdgeInsets? margin;
  final Color textColor;
  final EdgeInsets? padding;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 45,
      padding: padding,
      margin: margin ?? const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color,
        border: Border.all(width: 1, color: borderColor ?? color),
      ),
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  buttonName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
        ),
      ),
    );
  }
}
