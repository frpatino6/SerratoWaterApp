class UserData {
  final String id;
  final String address;
  final String email;
  final String firstName;
  final String lastName;
  final String parentUser;
  final String phone;
  final String socialSecurity;
  final int status;
  final String userType;

  UserData({
    required this.id,
    required this.address,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.parentUser,
    required this.phone,
    required this.socialSecurity,
    required this.status,
    required this.userType,
  });

  factory UserData.fromMap(Map<String, dynamic> map, String id) {
    return UserData(
      id: id,
      address: map['address'] ?? '',
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      parentUser: map['parent_user'] ?? '',
      phone: map['phone'] ?? '',
      socialSecurity: map['social_security'] ?? '',
      status: map['status']?.toInt() ?? 0,
      userType: map['userType'] ?? '',
    );
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData.fromMap(json, json['id']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'parent_user': parentUser,
      'phone': phone,
      'social_security': socialSecurity,
      'status': status,
      'userType': userType,
    };
  }
}
