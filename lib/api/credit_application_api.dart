import 'package:http/http.dart' as http;
import 'dart:convert';

class CreditApplicationApi {
  final String apiKey = "AIzaSyAlknAEEg2EroaQvYh9dPNM3Kda80CITvU";
  Future<void> postApplication(Map<String, dynamic> applicationData) async {
    const String url =
        'https://serratowaterapp-79627-default-rtdb.firebaseio.com/credit_application.json';

    final response = await http.post(
      Uri.parse(url),
      body: json.encode(applicationData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save application');
    }
  }
}
