import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healty_ways/model/appointment_model.dart';
import 'package:healty_ways/model/doctor_model.dart';
import 'package:healty_ways/resources/widgets/reusable_app_bar.dart';
import 'package:healty_ways/view_model/appointments_view_model.dart';
import 'package:healty_ways/view_model/auth_view_model.dart';
import 'package:healty_ways/view_model/profile_view_model.dart';
import 'package:intl/intl.dart';

/// ========================
/// BuildCalendar Widget
/// ========================
class BuildCalendar extends StatefulWidget {
  final Function(DateTime) onDateSelected; // Callback for date selection

  const BuildCalendar({Key? key, required this.onDateSelected})
      : super(key: key);

  @override
  State<BuildCalendar> createState() => _BuildCalendarState();
}

class _BuildCalendarState extends State<BuildCalendar> {
  DateTime _selectedDate = DateTime.now();
  final ScrollController _scrollController = ScrollController();

  // Generate a list of next 30 days
  List<DateTime> _generateNext30Days() {
    DateTime today = DateTime.now();
    return List.generate(30, (index) => today.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    final List<DateTime> days = _generateNext30Days();

    return Card(
      child: Container(
        height: 80,
        padding: const EdgeInsets.all(4),
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: days.length,
          itemBuilder: (context, index) {
            final date = days[index];
            return _CalendarDay(
              day: DateFormat('E').format(date), // Abbreviated day name
              date: DateFormat('d').format(date), // Day of month
              isSelected: _selectedDate.year == date.year &&
                  _selectedDate.month == date.month &&
                  _selectedDate.day == date.day,
              onTap: () {
                setState(() {
                  _selectedDate = date;
                });
                widget.onDateSelected(_selectedDate);
              },
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
    Key? key,
    required this.day,
    required this.date,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal : Colors.grey[300],
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

/// ========================
/// PatientBookAppointmentView
/// ========================
class PatientBookAppointmentView extends StatefulWidget {
  final DoctorModel doctor;
  const PatientBookAppointmentView({Key? key, required this.doctor})
      : super(key: key);

  @override
  _PatientBookAppointmentViewState createState() =>
      _PatientBookAppointmentViewState();
}

class _PatientBookAppointmentViewState
    extends State<PatientBookAppointmentView> {
  final AppointmentsViewModel appointmentsVM =
      Get.find<AppointmentsViewModel>();

  // Reservation duration variable (30 minutes by default)
  final Duration reservationDuration = const Duration(minutes: 30);

  // Currently selected date (default is today)
  DateTime selectedDate = DateTime.now();

  // List of available slots for the selected date
  List<DateTime> availableSlots = [];

  @override
  void initState() {
    super.initState();
    _generateAvailableSlots();
  }

  /// Generate available slots for the selected date.
  /// Uses the doctor's weekly schedule for the corresponding weekday.
  void _generateAvailableSlots() {
    final String weekday = _weekdayString(selectedDate.weekday);
    final List<AppointmentSlot> scheduleForDay =
        widget.doctor.weeklySchedule[weekday] ?? [];

    List<DateTime> slots = [];
    for (var slotRange in scheduleForDay) {
      // Build DateTime instances using selectedDate and the slot times.
      final DateTime rangeStart = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        slotRange.startTime.hour,
        slotRange.startTime.minute,
      );
      final DateTime rangeEnd = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        slotRange.endTime.hour,
        slotRange.endTime.minute,
      );

      DateTime current = rangeStart;
      // Generate reservationDuration increments (30 minutes by default)
      while (current.add(reservationDuration).isBefore(rangeEnd) ||
          current.add(reservationDuration).isAtSameMomentAs(rangeEnd)) {
        // Check if an appointment exists at this exact date/time slot.
        bool isBooked = appointmentsVM.appointments.any((appointment) {
          return appointment.time.year == current.year &&
              appointment.time.month == current.month &&
              appointment.time.day == current.day &&
              appointment.time.isAtSameMomentAs(current);
        });
        if (!isBooked) {
          slots.add(current);
        }
        current = current.add(reservationDuration);
      }
    }
    setState(() {
      availableSlots = slots;
    });
  }

  /// Converts weekday integer to day string.
  String _weekdayString(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return "Monday";
      case DateTime.tuesday:
        return "Tuesday";
      case DateTime.wednesday:
        return "Wednesday";
      case DateTime.thursday:
        return "Thursday";
      case DateTime.friday:
        return "Friday";
      case DateTime.saturday:
        return "Saturday";
      case DateTime.sunday:
        return "Sunday";
      default:
        return "";
    }
  }

  /// Formats DateTime as 12-hour string.
  String _formatTime(DateTime dt) {
    final TimeOfDay time = TimeOfDay.fromDateTime(dt);
    final String period = time.period == DayPeriod.am ? "AM" : "PM";
    final int hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final String minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute $period";
  }

  /// Confirm then book the appointment at the selected slot.
  Future<void> _confirmAndBookSlot(DateTime slot) async {
    bool confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Confirm Appointment"),
            content: Text(
                "Do you want to book an appointment at ${_formatTime(slot)} on ${DateFormat('EEE, MMM d, yyyy').format(selectedDate)}?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Confirm"),
              ),
            ],
          ),
        ) ??
        false;

    if (confirmed) {
      await _bookSlot(slot);
      // Show success message
      Get.snackbar("Success", "Appointment booked at ${_formatTime(slot)}");
      // Delay for a moment to allow the user to see the message
      await Future.delayed(const Duration(seconds: 1));
      // Pop this screen and go back to the doctor details screen
      Get.back();
    }
  }

  /// Book the appointment at the selected slot.
  Future<void> _bookSlot(DateTime slot) async {
    // Retrieve patient ID from ProfileViewModel
    final String? patientId = Get.find<ProfileViewModel>().profile?.uid;
    if (patientId == null) {
      Get.snackbar("Error", "Patient not logged in");
      return;
    }
    final appointment = AppointmentModel(
      doctorId: widget.doctor.uid,
      patientId: patientId,
      time: slot,
      status: AppointmentStatus.upcoming,
    );
    await appointmentsVM.bookAppointment(appointment);
    _generateAvailableSlots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        titleText: "Book Appointment",
        enableBack: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display doctor's name at the top.
            Text(
              widget.doctor.fullName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Calendar widget to select a date (next 30 days)
            BuildCalendar(
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });
                _generateAvailableSlots();
              },
            ),
            const SizedBox(height: 20),
            // Show available slots for the selected date.
            Expanded(
              child: availableSlots.isEmpty
                  ? const Center(
                      child: Text("No available slots for the selected day"),
                    )
                  : ListView.builder(
                      itemCount: availableSlots.length,
                      itemBuilder: (context, index) {
                        final slot = availableSlots[index];
                        return ListTile(
                          title: Text(_formatTime(slot)),
                          trailing: ElevatedButton(
                            onPressed: () => _confirmAndBookSlot(slot),
                            child: const Text("Book"),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
