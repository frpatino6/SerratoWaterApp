class SaleData {
  String id;
  String applicantId;
  String applicantName;
  String saleAmount;
  String salesRepresentative;
  String productsSold;
  String applicantFirstName;
  String applicantLastName;
  DateTime dateOfBirth;
  String phoneNumber;
  String email;
  String socialSecurityNumber;
  String idNumberDriverLicense;
  DateTime idIssueDate;
  DateTime expirationDate;
  int timeAtResidence;
  String address;
  String state;
  String cityZipCode;
  bool installationAddressDifferent;
  String monthlyMortgagePayment;
  String employerName;
  String employerPhoneNumber;
  String occupation;
  String timeAtCurrentJob;
  String employmentMonthlyIncome;
  String otherIncome;
  String sourceOfOtherIncome;
  String forIDPurposes;
  String creditCardExpirationDate;
  bool isACHInfoAdded;
  bool isIncomeNoticeChecked;
  bool isCoApplicantAdded;
  String user;
  String installationAddress;
  String installationCity;
  String installationState;
  String installationZipCode;
  String applicationState;
  String installationDate;
  SaleData(
      {required this.id,
      required this.applicantId,
      required this.applicantName,
      required this.saleAmount,
      required this.salesRepresentative,
      required this.productsSold,
      required this.applicantFirstName,
      required this.applicantLastName,
      required this.dateOfBirth,
      required this.phoneNumber,
      required this.email,
      required this.socialSecurityNumber,
      required this.idNumberDriverLicense,
      required this.idIssueDate,
      required this.expirationDate,
      required this.timeAtResidence,
      required this.address,
      required this.state,
      required this.cityZipCode,
      required this.installationAddressDifferent,
      required this.monthlyMortgagePayment,
      required this.employerName,
      required this.employerPhoneNumber,
      required this.occupation,
      required this.timeAtCurrentJob,
      required this.employmentMonthlyIncome,
      required this.otherIncome,
      required this.sourceOfOtherIncome,
      required this.forIDPurposes,
      required this.creditCardExpirationDate,
      required this.isACHInfoAdded,
      required this.isIncomeNoticeChecked,
      required this.isCoApplicantAdded,
      required this.user,
      required this.installationAddress,
      required this.installationCity,
      required this.installationState,
      required this.installationZipCode,
      required this.applicationState,
      required this.installationDate});

  // Método para convertir un objeto SaleData a un mapa, útil para operaciones de base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'applicantId': applicantId,
      'saleAmount': saleAmount,
      'salesRepresentative': salesRepresentative,
      'productsSold': productsSold,
      'applicantFirstName': applicantFirstName,
      'applicantLastName': applicantLastName,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'phoneNumber': phoneNumber,
      'email': email,
      'socialSecurityNumber': socialSecurityNumber,
      'idNumberDriverLicense': idNumberDriverLicense,
      'idIssueDate': idIssueDate.toIso8601String(),
      'expirationDate': expirationDate.toIso8601String(),
      'timeAtResidence': timeAtResidence,
      'address': address,
      'state': state,
      'cityZipCode': cityZipCode,
      'installationAddressDifferent': installationAddressDifferent,
      'monthlyMortgagePayment': monthlyMortgagePayment,
      'employerName': employerName,
      'employerPhoneNumber': employerPhoneNumber,
      'occupation': occupation,
      'timeAtCurrentJob': timeAtCurrentJob,
      'employmentMonthlyIncome': employmentMonthlyIncome,
      'otherIncome': otherIncome,
      'sourceOfOtherIncome': sourceOfOtherIncome,
      'forIDPurposes': forIDPurposes,
      'creditCardExpirationDate': creditCardExpirationDate,
      'isACHInfoAdded': isACHInfoAdded,
      'isIncomeNoticeChecked': isIncomeNoticeChecked,
      'isCoApplicantAdded': isCoApplicantAdded,
      'user': user,
      'installationAddress': installationAddress,
      'installationCity': installationCity,
      'installationState': installationState,
      'installationZipCode': installationZipCode,
      'installationDate': installationDate
    };
  }

  // Método para crear un objeto SaleData desde un mapa, útil para operaciones de base de datos
  static SaleData fromMap(String id, Map<String, dynamic> map) {
    return SaleData(
      id: id,
      applicantId: map['applicantId'],
      applicantName: map['applicantName'],
      saleAmount: map['saleAmount'],
      salesRepresentative: map['salesRepresentative'],
      productsSold: map['productsSold'],
      applicantFirstName: map['applicantFirstName'] ?? '',
      applicantLastName: map['applicantLastName'] ?? '',
      dateOfBirth: DateTime.parse(map['dateOfBirth']),
      phoneNumber: map['phoneNumber'],
      email: map['email'],
      socialSecurityNumber: map['socialSecurityNumber'] ?? '',
      idNumberDriverLicense: map['idNumberDriverLicense'] ?? '',
      idIssueDate: DateTime.parse(map['idIssueDate']),
      expirationDate: DateTime.parse(map['expirationDate']),
      timeAtResidence: map['timeAtResidence'],
      address: map['address'],
      state: map['state'],
      cityZipCode: map['cityZipCode'],
      installationAddressDifferent: map['installationAddressDifferent'],
      monthlyMortgagePayment: map['monthlyMortgagePayment'],
      employerName: map['employerName'],
      employerPhoneNumber: map['employerPhoneNumber'],
      occupation: map['occupation'],
      timeAtCurrentJob: map['timeAtCurrentJob'],
      employmentMonthlyIncome: map['employmentMonthlyIncome'],
      otherIncome: map['otherIncome'],
      sourceOfOtherIncome: map['sourceOfOtherIncome'],
      forIDPurposes: map['forIDPurposes'],
      creditCardExpirationDate: map['creditCardExpirationDate'],
      isACHInfoAdded: map['isACHInfoAdded'],
      isIncomeNoticeChecked: map['isIncomeNoticeChecked'],
      isCoApplicantAdded: map['isCoApplicantAdded'],
      user: map['userOwner'],
      installationAddress: map['installationAddress'] ?? '',
      installationCity: map['installationCity'] ?? '',
      installationState: map['installationState'] ?? '',
      installationZipCode: map['installationZipCode'] ?? '',
      applicationState: map['applicationState'] ?? '',
      installationDate: map['installationDate'] ?? '',
    );
  }

  static SaleData fromJson(Map<String, dynamic> json, String id) {
    var data = json.values.first;

    return SaleData(
      id: data['id'] ?? '',
      applicantId: data['applicantId'] ?? '',
      applicantName: data['applicantName'] ?? '',
      saleAmount: data['saleAmount'] ?? '',
      salesRepresentative: data['salesRepresentative'] ?? '',
      productsSold: data['productsSold'] ?? '',
      applicantFirstName: data['applicantName']?.split(' ')[0] ??
          '', // Asumiendo que 'applicantName' contiene el nombre completo
      applicantLastName: data['applicantName']?.split(' ').skip(1).join(' ') ??
          '', // Asumiendo que 'applicantName' contiene el nombre completo
      dateOfBirth:
          DateTime.parse(data['dateOfBirth'] ?? '0000-00-00T00:00:00.000'),
      phoneNumber: data['phoneNumber'] ?? '',
      email: data['email'] ?? '',
      socialSecurityNumber: data['socialSecurityNumber'] ?? '',
      idNumberDriverLicense: data['idNumberDriverLicense'] ?? '',
      idIssueDate:
          DateTime.parse(data['idIssueDate'] ?? '0000-00-00T00:00:00.000'),
      expirationDate:
          DateTime.parse(data['expirationDate'] ?? '0000-00-00T00:00:00.000'),
      timeAtResidence: data['timeAtResidence'] ?? 0,
      address: data['address'] ?? '',
      state: data['state'] ?? '',
      cityZipCode: data['cityZipCode'] ?? '',
      installationAddressDifferent:
          data['installationAddressDifferent'] ?? 'No',
      monthlyMortgagePayment: data['monthlyMortgagePayment'] ?? '',
      employerName: data['employerName'] ?? '',
      employerPhoneNumber: data['employerPhoneNumber'] ?? '',
      occupation: data['occupation'] ?? '',
      timeAtCurrentJob: data['timeAtCurrentJob'] ?? '',
      employmentMonthlyIncome: data['employmentMonthlyIncome'] ?? '',
      otherIncome: data['otherIncome'] ?? '',
      sourceOfOtherIncome: data['sourceOfOtherIncome'] ?? '',
      forIDPurposes: data['forIDPurposes'] ?? 'VISA',
      creditCardExpirationDate: data['creditCardExpirationDate'] ?? '',
      isACHInfoAdded: data['isACHInfoAdded'] ?? false,
      isIncomeNoticeChecked: data['isIncomeNoticeChecked'] ?? false,
      isCoApplicantAdded: data['isCoApplicantAdded'] ?? false,
      user: data['userOwner'] ?? '',
      installationAddress: data['installationAddress'] ?? '',
      installationCity: data['installationCity'] ?? '',
      installationState: data['installationState'] ?? '',
      installationZipCode: data['installationZipCode'] ?? '',
      applicationState: data['applicationState'] ?? '',
      installationDate: data['installationDate'] ?? '',
    );
  }
}
