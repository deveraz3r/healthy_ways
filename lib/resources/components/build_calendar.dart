import 'package:flutter/material.dart';
import 'package:healty_ways/resources/app_colors.dart';

class BuildCalendar extends StatelessWidget {
  const BuildCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            _CalendarDay('Sun', '12'),
            _CalendarDay('Mon', '13'),
            _CalendarDay('Tue', '14'),
            _CalendarDay('Wed', '15'),
            _CalendarDay('Thu', '16'),
            _CalendarDay('Fri', '17'),
            _CalendarDay('Sat', '18'),
          ],
        ),
      ),
    );
  }
}

class _CalendarDay extends StatelessWidget {
  final String day;
  final String date;

  const _CalendarDay(this.day, this.date);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: day == 'Sun' ? AppColors.primaryColor : null,
          borderRadius: BorderRadius.circular(6)),
      child: Column(
        children: [
          Text(day,
              style:
                  TextStyle(color: day == 'Sun' ? Colors.white : Colors.grey)),
          const SizedBox(height: 4),
          Text(
            date,
            style: TextStyle(color: day == 'Sun' ? Colors.white : Colors.black),
          ),
        ],
      ),
    );
  }
}
