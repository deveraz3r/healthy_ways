import 'package:healty_ways/utils/app_urls.dart';

class HomeButton extends StatelessWidget {
  final String title;
  final GestureTapCallback onTap;
  final Color color;

  const HomeButton({
    super.key,
    required this.title,
    required this.onTap,
    this.color = AppColors.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
