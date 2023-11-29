class UserTypeData {
  final String type;
  final String userTypeParent;

  UserTypeData({required this.type, required this.userTypeParent});

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'user_type_parent': userTypeParent,
    };
  }

  // create to map
  static UserTypeData fromMap(Map<String, dynamic> map) {
    return UserTypeData(
      type: map['type'],
      userTypeParent: map['user_type_parent'],
    );
  }

  // create from json
  static UserTypeData fromJson(Map<String, dynamic> json) {
    return UserTypeData(
      type: json['type'],
      userTypeParent: json['user_type_parent'],
    );
  }

  // create ToMap
  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'user_type_parent': userTypeParent,
    };
  }
}
