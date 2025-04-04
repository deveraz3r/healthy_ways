import 'package:healty_ways/model/medicine_model.dart';
import 'package:healty_ways/utils/app_urls.dart';

class MedicineScheduleModel {
  final MedicineModel medicine;
  DateTime startDate;
  DateTime endDate;
  List<TimeOfDay> times;

  MedicineScheduleModel(this.medicine)
      : startDate = DateTime.now(),
        endDate = DateTime.now(),
        times = [];
}
