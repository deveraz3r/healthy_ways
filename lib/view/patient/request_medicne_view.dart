import 'package:flutter/material.dart';

class RequestMedicneView extends StatefulWidget {
  @override
  _RequestMedicneViewState createState() => _RequestMedicneViewState();
}

class _RequestMedicneViewState extends State<RequestMedicneView> {
  String selectedPaymentMethod = "Payoneer"; // Default selected payment

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
            // Medicine Details Card
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Medicine Details",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),

                    // Medicine Name Input
                    buildTextField("Medicine Name", "Medicine name"),
                    SizedBox(height: 12),

                    // Formula Input
                    buildTextField("Formula", "Formula"),
                    SizedBox(height: 12),

                    // Quantity Input
                    buildTextField("Quantity", "quantity e.g. 2"),
                    SizedBox(height: 8),

                    // Add New Button
                    TextButton(
                      onPressed: () {},
                      child: Text("+ Add new",
                          style: TextStyle(color: Colors.teal)),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Payment Method Section
            Text(
              "Payment Method:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                buildRadioOption("Payoneer"),
                buildRadioOption("Paypal"),
              ],
            ),
            SizedBox(height: 24),

            // Continue Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  "CONTINUE",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to Build a Custom Text Field
  Widget buildTextField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 6),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }

  // Function to Build a Radio Button Option
  Widget buildRadioOption(String paymentMethod) {
    return Row(
      children: [
        Radio(
          value: paymentMethod,
          groupValue: selectedPaymentMethod,
          onChanged: (value) {
            setState(() {
              selectedPaymentMethod = value.toString();
            });
          },
          activeColor: Colors.teal,
        ),
        Text(paymentMethod),
      ],
    );
  }
}
