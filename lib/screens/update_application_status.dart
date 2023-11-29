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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          // Usar ListView para evitar problemas de desbordamiento
          children: [
            Text('Applicant Name:', style: headingStyle),
            Text(saleData.applicantName, style: contentStyle),
            const SizedBox(height: 16),
            Text('Address:', style: headingStyle),
            Text(saleData.address, style: contentStyle),
            const SizedBox(height: 16),
            Text('Product List', style: headingStyle),
            ...products
                .map((product) => Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Text(product, style: contentStyle),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
