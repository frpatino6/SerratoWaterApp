import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serrato_water_app/models/user_type_data.dart';

class UsertTypeApi {
  Future<List<UserTypeData>> getUserType() async {
    final url = Uri.parse(
        'https://serratowaterapp-79627-default-rtdb.firebaseio.com/user_type.json');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      List<UserTypeData> userTypeDataList = [];

      data.forEach((key, value) {
        UserTypeData userTypeData =
            UserTypeData.fromMap(value as Map<String, dynamic>);
        userTypeDataList.add(userTypeData);
      });

      return userTypeDataList;
    } else {
      throw Exception('Failed to load sales data');
    }
  }
}
