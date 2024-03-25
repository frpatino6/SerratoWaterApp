// ignore_for_file: unused_import

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serrato_water_app/models/user_data.dart';
import 'package:serrato_water_app/models/user_type_data.dart';

class UsersApi {
  Future<List<UserData>> getUsersInstaller() async {
    final url = Uri.parse(
        'https://serratowaterapp-79627-default-rtdb.firebaseio.com/user_extend_info.json');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      List<UserData> userTypeDataList = [];

      data.forEach((key, value) {
        if (value['userType'] == 'Installer') {
          UserData installerData =
              UserData.fromMap(value as Map<String, dynamic>, key);
          userTypeDataList.add(installerData);
        }
      });

      return userTypeDataList;
    } else {
      throw Exception('Failed to load sales data');
    }
  }
}
