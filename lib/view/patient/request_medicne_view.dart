import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/order_view_model.dart';

class RequestMedicneView extends StatefulWidget {
  @override
  _RequestMedicneViewState createState() => _RequestMedicneViewState();
}

class _RequestMedicneViewState extends State<RequestMedicneView> {
  final OrderViewModel viewModel = Get.put(OrderViewModel());
  final List<MedicineItem> _medicines =
      []; // Temporary list for medicines before checkout

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _formulaController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Medicine Details"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // List of Medicine Cards
            Expanded(
              child: ListView.builder(
                itemCount: _medicines.length,
                itemBuilder: (context, index) {
                  final medicine = _medicines[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Medicine ${index + 1}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text("Name: ${medicine.name}"),
                          Text("Formula: ${medicine.formula}"),
                          Text("Quantity: ${medicine.quantity}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),

            // Add Medicine Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Add Medicine",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    buildTextField(
                      "Medicine Name",
                      "Medicine name",
                      _nameController,
                      null,
                    ),
                    SizedBox(height: 12),
                    buildTextField(
                      "Formula",
                      "Formula",
                      _formulaController,
                      null,
                    ),
                    SizedBox(height: 12),
                    buildTextField(
                      "Quantity",
                      "Quantity e.g. 2",
                      _quantityController,
                      TextInputType.number,
                    ),
                    SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        // Add new medicine to temporary list
                        if (_nameController.text.isNotEmpty &&
                            _quantityController.text.isNotEmpty) {
                          setState(() {
                            _medicines.add(MedicineItem(
                              name: _nameController.text,
                              formula: _formulaController.text,
                              quantity: int.parse(_quantityController.text),
                            ));
                          });

                          // Clear input fields
                          _nameController.clear();
                          _formulaController.clear();
                          _quantityController.clear();
                        }
                      },
                      child: Text(
                        "+ Add new",
                        style: TextStyle(color: Colors.teal),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Checkout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _medicines.isEmpty
                    ? null
                    : () {
                        // Pass medicines to checkout view
                        Get.toNamed(
                          RouteName.patientRequestMedicineCheckout,
                          arguments: _medicines,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  "CHECKOUT",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to Build a Custom Text Field
  Widget buildTextField(
    String label,
    String hint,
    TextEditingController controller,
    TextInputType? inputType,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: inputType,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }
}

// Simple model to represent medicine items before creating an order
class MedicineItem {
  final String name;
  final String formula;
  final int quantity;

  MedicineItem({
    required this.name,
    required this.formula,
    required this.quantity,
  });
}
