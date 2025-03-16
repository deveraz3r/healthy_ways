import 'package:get/get.dart';
import 'package:healty_ways/model/patient/pharmacy_delivery.dart';

class PharmacyDeliveryViewModel extends GetxController {
  // List of medicine deliveries (reactive)
  final RxList<PharmacyDelivery> deliveries = <PharmacyDelivery>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Load deliveries when the ViewModel is initialized
    _loadDeliveries();
  }

  // Simulate loading deliveries (replace with API call in a real app)
  void _loadDeliveries() {
    final List<PharmacyDelivery> loadedDeliveries = [
      PharmacyDelivery(
        date: DateTime(2023, 10, 15),
        dayAbbreviation: '15',
        monthAbbreviation: 'Oct',
        deliveries: [
          DeliveryEntry(
            orderId: 'ORD12345',
            status: DeliveryStatus.completed,
            requestedDate: DateTime(2023, 10, 10),
            deliveredDate: DateTime(2023, 10, 15),
            updateMessages: [
              'Order placed on Oct 10, 2023',
              'Order shipped on Oct 12, 2023',
              'Order delivered on Oct 15, 2023',
            ],
            medicines: [
              Medicine(name: 'Paracetamol', quantity: 2),
              Medicine(name: 'Ibuprofen', quantity: 1),
              Medicine(name: 'Vitamin C', quantity: 3),
            ],
          ),
          DeliveryEntry(
            orderId: 'ORD67890',
            status: DeliveryStatus.inProgress,
            requestedDate: DateTime(2023, 10, 12),
            updateMessages: [
              'Order placed on Oct 12, 2023',
              'Order shipped on Oct 14, 2023',
              'Order is in transit to your city',
            ],
            medicines: [
              Medicine(name: 'Amoxicillin', quantity: 1),
              Medicine(name: 'Cetirizine', quantity: 2),
            ],
          ),
        ],
      ),
      PharmacyDelivery(
        date: DateTime(2023, 10, 20),
        dayAbbreviation: '20',
        monthAbbreviation: 'Oct',
        deliveries: [
          DeliveryEntry(
            orderId: 'ORD54321',
            status: DeliveryStatus.notStarted,
            requestedDate: DateTime(2023, 10, 18),
            updateMessages: [
              'Order placed on Oct 18, 2023',
              'Order is being processed',
            ],
            medicines: [
              Medicine(name: 'Metformin', quantity: 1),
              Medicine(name: 'Atorvastatin', quantity: 1),
            ],
          ),
        ],
      ),
    ];

    deliveries.assignAll(loadedDeliveries); // Update the reactive list
  }
}
