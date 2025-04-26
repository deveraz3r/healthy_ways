import 'package:healty_ways/utils/app_urls.dart';

class BuildCalendar extends StatefulWidget {
  final Function(DateTime) onDateSelected; // Callback for date selection

  const BuildCalendar({super.key, required this.onDateSelected});

  @override
  State<BuildCalendar> createState() => _BuildCalendarState();
}

class _BuildCalendarState extends State<BuildCalendar> {
  DateTime _selectedDate = DateTime.now(); // Track the selected date
  final ScrollController _scrollController =
      ScrollController(); // For horizontal scrolling

  @override
  void initState() {
    super.initState();
    // Scroll to the end of the list to show the current week
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  // Generate a list of weeks (each week is a list of days)
  List<List<DateTime>> _generateWeeks() {
    final List<List<DateTime>> weeks = [];
    DateTime startDate =
        DateTime.now().subtract(const Duration(days: 30)); // 30 days ago
    DateTime endDate =
        DateTime.now().add(const Duration(days: 30)); // 30 days ahead

    for (DateTime date = startDate;
        !date.isAfter(endDate);
        date = date.add(const Duration(days: 1))) {
      if (date.weekday == DateTime.sunday || weeks.isEmpty) {
        weeks.add([]); // Start a new week
      }
      weeks.last.add(date); // Add the date to the current week
    }

    return weeks;
  }

  @override
  Widget build(BuildContext context) {
    final List<List<DateTime>> weeks = _generateWeeks();

    return Card(
      child: Container(
        height: 80, // Fixed height for the calendar
        padding: EdgeInsets.all(4),
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: weeks.length,
          itemBuilder: (context, weekIndex) {
            final week = weeks[weekIndex];
            return Row(
              children: week.map((date) {
                return _CalendarDay(
                  day: DateFormat('E')
                      .format(date), // Abbreviated day name (e.g., "Sun")
                  date: DateFormat('d')
                      .format(date), // Day of the month (e.g., "12")
                  isSelected: _selectedDate.day == date.day &&
                      _selectedDate.month == date.month,
                  onTap: () {
                    setState(() {
                      _selectedDate = date; // Update the selected date
                    });
                    widget.onDateSelected(
                        _selectedDate); // Notify the parent widget
                  },
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

class _CalendarDay extends StatelessWidget {
  final String day;
  final String date;
  final bool isSelected;
  final VoidCallback onTap;

  const _CalendarDay({
    required this.day,
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Handle tap events
      child: Container(
        width: 40, // Fixed width for each day
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : null,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
