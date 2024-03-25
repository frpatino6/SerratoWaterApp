import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:serrato_water_app/models/sales_data.dart';

class CreditApplicationApi {
  final String apiKey = "AIzaSyAlknAEEg2EroaQvYh9dPNM3Kda80CITvU";
  String url =
      'https://serratowaterapp-79627-default-rtdb.firebaseio.com/credit_application.json';

  Future<void> postApplication(Map<String, dynamic> applicationData) async {
    final response = await http.post(
      Uri.parse(url),
      body: json.encode(applicationData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save application');
    }
  }

  Future<List<SaleData>> getSalesData(String user) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      List<SaleData> salesDataList = [];

      data.forEach((key, value) {
        // Asegúrate de que el constructor y fromMap ahora incluyan el ID
        SaleData saleData =
            SaleData.fromMap(key, value as Map<String, dynamic>);
        if (saleData.user == user) {
          salesDataList.add(saleData);
        }
      });

      return salesDataList;
    } else {
      throw Exception('Failed to load sales data');
    }
  }

  Future<List<SaleData>> getAllSalesData() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      List<SaleData> salesDataList = [];

      data.forEach((key, value) {
        // Asegúrate de que el constructor y fromMap ahora incluyan el ID
        SaleData saleData =
            SaleData.fromMap(key, value as Map<String, dynamic>);

        salesDataList.add(saleData);
      });

      return salesDataList;
    } else {
      throw Exception('Failed to load sales data');
    }
  }

  // add method to update sales status
  Future<String> updateSalesStatus(String salesId, String status) async {
    String url =
        'https://serratowaterapp-79627-default-rtdb.firebaseio.com/credit_application/$salesId.json';

    final response = await http.patch(
      Uri.parse(url),
      body: json.encode({'applicationState': status}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update sales status');
    }

    return 'Sales status updated';
  }

  Future<String> updateSalesStatusAndInstaller(
      String salesId, String status, String emailInstaller) async {
    String url =
        'https://serratowaterapp-79627-default-rtdb.firebaseio.com/credit_application/$salesId.json';

    final response = await http.patch(
      Uri.parse(url),
      body: json.encode({
        'applicationState': status,
        'userOwner': emailInstaller,
        'installationDate': DateTime.now().toString()
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update sales status');
    }

    return 'Sales status updated';
  }
}
