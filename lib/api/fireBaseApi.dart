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

  Future<Map<String, dynamic>> signUp(
      String email, String password, String firstName, String lastName) async {
    final String signUpUrl =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey';

    final response = await http.post(
      Uri.parse(signUpUrl),
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create account');
    }

    final responseData = json.decode(response.body);
    // save the user info
    await postUserExtendInfo(email, password, firstName, lastName);
    // disable the user
    await disableUser(responseData['idToken']);

    return responseData;
  }

  Future<void> disableUser(String idToken) async {
    final String updateUrl =
        'https://identitytoolkit.googleapis.com/v1/accounts:update?key=$apiKey';

    final disableResponse = await http.post(
      Uri.parse(updateUrl),
      body: json.encode({
        'idToken': idToken,
        'disableUser': true,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (disableResponse.statusCode != 200) {
      throw Exception('Failed to disable user account');
    }
  }

  Future<void> postUserExtendInfo(
      String email, String password, String firstName, String lastName) async {
    String url =
        'https://serratowaterapp-79627-default-rtdb.firebaseio.com/user_extend_info.json';
    final response = await http.post(
      Uri.parse(url),
      body: json.encode(
          {'email': email, 'firstName': firstName, 'lastName': lastName}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save application');
    }
  }

  Future<List<String>> loadUserListFromDatabase(String selectedUserType) async {
    String url =
        'https://serratowaterapp-79627-default-rtdb.firebaseio.com/user_extend_info.json';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<String> userList = [];

      data.forEach((key, value) {
        if (value['userType'] == selectedUserType) {
          userList.add(value['email']);
        }
      });

      return userList;
    } else {
      throw Exception('Failed to load user list');
    }
  }
}
