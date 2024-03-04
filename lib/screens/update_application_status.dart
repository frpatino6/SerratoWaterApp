import 'package:flutter/material.dart';
import 'package:serrato_water_app/models/sales_data.dart';

class UpdateApplicationStatus extends StatelessWidget {
  final SaleData saleData;

  const UpdateApplicationStatus({super.key, required this.saleData});

  @override
  Widget build(BuildContext context) {
    List<String> products = saleData.productsSold.split(',');

    TextStyle headingStyle = const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.blueGrey,
    );

    TextStyle contentStyle = const TextStyle(
      fontSize: 16,
      color: Colors.black54,
    );

    List<String> statusOptions = [
      "Submitted",
      "Under Review",
      "Declined",
      "Approved",
      "Pending Installation",
      "Installed",
      "Pending Verification",
      "Funding Process",
      "Completed",
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Applicant Name:', style: headingStyle),
            Text(saleData.applicantName, style: contentStyle),
            const SizedBox(height: 16),
            Text('Address:', style: headingStyle),
            Text(saleData.address, style: contentStyle),
            const SizedBox(height: 16),
            Text('Status:', style: headingStyle),
            DropdownButtonFormField<String>(
              value: statusOptions.contains(saleData.applicationState)
                  ? saleData.applicationState
                  : null,
              items:
                  statusOptions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {},
            ),
            const SizedBox(height: 16),
            Text('Product List', style: headingStyle),
            const SizedBox(height: 8),
            ...products.map((product) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile(
                  leading: const Icon(Icons.check_circle_outline,
                      color: Colors.blue),
                  title: Text(product, style: contentStyle),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
