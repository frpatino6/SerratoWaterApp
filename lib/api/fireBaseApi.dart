import 'package:http/http.dart' as http;
import 'dart:convert';

class FirebaseAPI {
  final String apiKey = "AIzaSyAlknAEEg2EroaQvYh9dPNM3Kda80CITvU";

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    final String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey';
    final response = await http.post(Uri.parse(url), // Modificación aquí
        body: json.encode(
            {'email': email, 'password': password, 'returnSecureToken': true}));
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> signUp(String email, String password) async {
    final String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey';
    final response = await http.post(Uri.parse(url), // Modificación aquí
        body: json.encode(
            {'email': email, 'password': password, 'returnSecureToken': true}));
    return json.decode(response.body);
  }

  Future<void> postApplication(Map<String, dynamic> applicationData) async {
    final String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey';

    final response = await http.post(
      Uri.parse('$url/credit_applications'),
      body: json.encode(applicationData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save application');
    }
  }
}
