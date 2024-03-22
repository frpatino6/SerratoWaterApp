import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serrato_water_app/bloc/sales_list/sales_bloc.dart';
import 'package:serrato_water_app/bloc/sales_list/sales_event.dart';
import 'package:serrato_water_app/models/sales_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        bool isDropdownEnabled = true;
        String dropdownValue =
            saleData.applicationState; // Usa el valor actual por defecto

        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final prefs = snapshot.data!;
          final userType = prefs.getString('userType');
          if (userType == "SuperAdministrator" &&
              saleData.applicationState == "Submitted") {
            dropdownValue = "Under Review";
          } else {
            isDropdownEnabled = false;
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Application Details'),
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  // Obtener la instancia del Bloc
                  final salesBloc = BlocProvider.of<SalesBloc>(context);
                  //
                  final newState =
                      dropdownValue; // Este sería el valor actual seleccionado en tu Dropdown
                  final salesId = saleData
                      .id; // Asumiendo que tu objeto 'saleData' tiene un campo 'id'

                  // // Despachar el evento para actualizar el estado de la venta
                  salesBloc.add(UpdateSalesStatusEvent(salesId, newState));

                  // Muestra un mensaje indicando que la acción se está ejecutando
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Updating sales status...')),
                  );
                },
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
                  value: dropdownValue,
                  items: statusOptions
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: isDropdownEnabled
                      ? (newValue) {}
                      : null, // Controla si el dropdown es modificable
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
      },
    );
  }
}
