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
      String email,
      String password,
      String userType,
      String firstName,
      String lastName,
      String address,
      String parentUser,
      String phone) async {
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
    await postUserExtendInfo(email, password, userType, firstName, lastName,
        address, parentUser, phone);

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
      String email,
      String password,
      String userType,
      String firstName,
      String lastName,
      String address,
      String parentUser,
      String phone) async {
    String url =
        'https://serratowaterapp-79627-default-rtdb.firebaseio.com/user_extend_info.json';

    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'address': address,
        'phone': phone,
        'userType': userType,
        'parent_user': parentUser,
        'social_security': password
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save application');
    }
  }

  Future<void> putUserExtendInfo(String id, email, String firstName,
      String lastName, String address, String phone) async {
    // Asumiendo que 'userId' es el identificador único del usuario.
    String nodeId = "-NdwgNZe1oXP6UvCm1_q";
    String url =
        'https://serratowaterapp-79627-default-rtdb.firebaseio.com/user_extend_info/$nodeId.json';

    final response = await http.put(
      Uri.parse(url),
      body: json.encode({
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'address': address,
        'phone': phone
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user information');
    }
  }

  Future<List<String>> loadUserListFromDatabase(String selectedUserType) async {
    String url =
        'https://serratowaterapp-79627-default-rtdb.firebaseio.com/user_extend_info.json';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<String> userList = [];

      for (var entry in data.entries) {
        if (entry.value['userType'] == selectedUserType) {
          userList.add(entry.value['email']);
        }
      }

      return userList;
    } else {
      throw Exception('Failed to load user list');
    }
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final encodedEmail = Uri.encodeComponent(email);
    final url = Uri.parse(
        'https://serratowaterapp-79627-default-rtdb.firebaseio.com/user_extend_info.json?orderBy="email"&equalTo="$encodedEmail"');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      // Si la respuesta no está vacía, devolvemos el primer usuario.
      if (data.isNotEmpty) {
        final firstKey = data.keys.first;
        final user = data[firstKey];

        user['id'] = firstKey;
        return user;
      }
      // Si no hay datos, retornamos null para indicar que no se encontró ningún usuario.
      return null;
    } else {
      throw Exception('Failed to load user');
    }
  }
}
