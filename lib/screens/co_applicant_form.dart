import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:serrato_water_app/widgets/addres_information.dart';
import 'package:serrato_water_app/widgets/identification_information.dart';
import 'package:serrato_water_app/widgets/personal_information.dart';
import 'package:serrato_water_app/widgets/work_information.dart';

class CoApplicantForm extends StatefulWidget {
  const CoApplicantForm({super.key});

  @override
  _CoApplicantFormState createState() => _CoApplicantFormState();
}

class _CoApplicantFormState extends State<CoApplicantForm> {
  final _formKey = GlobalKey<FormState>();
  // Define las variables necesarias para tu formulario aquí
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _applicantFirstNameController =
      TextEditingController();
  final TextEditingController _applicantLastNameController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _socialSecurityNumberController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityZipCodeController = TextEditingController();
  final TextEditingController _timeAtResidenceController =
      TextEditingController();
  final TextEditingController _monthlyMortgagePaymentController =
      TextEditingController();
  final TextEditingController _idNumberDriverLicenseController =
      TextEditingController();
  final TextEditingController _idIssueDateController = TextEditingController();
  final TextEditingController _expirationDateController =
      TextEditingController();
  final TextEditingController _forIDPurposesController =
      TextEditingController();
  final TextEditingController _creditCardExpirationDateController =
      TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _employerNameController = TextEditingController();
  final TextEditingController _employerPhoneNumberController =
      TextEditingController();
  final TextEditingController _employmentMonthlyIncomeController =
      TextEditingController();
  final TextEditingController _otherIncomeController = TextEditingController();
  final TextEditingController _sourceOfOtherIncomeController =
      TextEditingController();
  final TextEditingController _timeAtCurrentJobController =
      TextEditingController();

  DateTime _dateOfBirth = DateTime.now();
  DateTime _idIssueDate = DateTime.now();
  DateTime _expirationDate = DateTime.now();

  final List<String> _statesList = [
    "Alabama",
    "Alaska",
    "Arizona",
    "Arkansas",
    "California",
    "Colorado",
    "Connecticut",
    "Delaware",
    "Florida",
    "Georgia",
    "Hawaii",
    "Idaho",
    "Illinois",
    "Indiana",
    "Iowa",
    "Kansas",
    "Kentucky",
    "Louisiana",
    "Maine",
    "Maryland",
    "Massachusetts",
    "Michigan",
    "Minnesota",
    "Mississippi",
    "Missouri",
    "Montana",
    "Nebraska",
    "Nevada",
    "New Hampshire",
    "New Jersey",
    "New Mexico",
    "New York",
    "North Carolina",
    "North Dakota",
    "Ohio",
    "Oklahoma",
    "Oregon",
    "Pennsylvania",
    "Rhode Island",
    "South Carolina",
    "South Dakota",
    "Tennessee",
    "Texas",
    "Utah",
    "Vermont",
    "Virginia",
    "Washington",
    "West Virginia",
    "Wisconsin",
    "Wyoming"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Co-Applicant'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // Tus campos de formulario van aquí
              ElevatedButton(
                onPressed: () async {
                  final DateTime? initialDate =
                      _dateOfBirthController.text.isNotEmpty
                          ? DateFormat('dd/MM/yyyy')
                              .parse(_dateOfBirthController.text)
                          : null;
                  final result = await showDialog<Map<String, dynamic>>(
                    context: context,
                    builder: (BuildContext context) =>
                        PersonalInformationDialog(
                      initialFirstName: _applicantFirstNameController.text,
                      initialLastName: _applicantLastNameController.text,
                      initialDateOfBirth: initialDate,
                      initialPhoneNumber: _phoneNumberController.text,
                      initialEmail: _emailController.text,
                      initialSocialSecurityNumber:
                          _socialSecurityNumberController.text,
                    ),
                  );

                  if (result != null) {
                    DateTime dateOfBirth = result['dateOfBirth'];
                    String formattedDate =
                        DateFormat('dd/MM/yyyy').format(dateOfBirth);
                    _applicantFirstNameController.text = result['firstName'];

                    _dateOfBirth = dateOfBirth;

                    _applicantLastNameController.text = result['lastName'];
                    _dateOfBirthController.text = formattedDate;
                    _phoneNumberController.text = result['phoneNumber'];
                    _emailController.text = result['email'];
                    _socialSecurityNumberController.text =
                        result['socialSecurityNumber'];
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueGrey, // color del botón
                  minimumSize: const Size(88, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                ),
                child: const Text('Personal Information'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final result = await showDialog<Map<String, dynamic>>(
                    context: context,
                    builder: (BuildContext context) {
                      return AddressInformation(
                        stateList: _statesList,
                        initialAddress: _addressController.text,
                        initialCity: _cityController.text,
                        initialState: _stateController.text,
                        initialCityZipCode: _cityZipCodeController.text,
                        initialMonthlyMortgagePayment:
                            _monthlyMortgagePaymentController.text,
                        initialTimeAtResidence: _timeAtResidenceController.text,
                      );
                    },
                  );

                  if (result != null) {
                    _addressController.text = result['address'];
                    _cityController.text = result['city'];
                    _stateController.text = result['state'];
                    _cityZipCodeController.text = result['zipCode'];
                    _timeAtResidenceController.text =
                        result['timeAtResidence'].toString();
                    _monthlyMortgagePaymentController.text =
                        result['monthlyMortgagePayment'].toString();
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueGrey, // color del botón
                  minimumSize: const Size(88, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                ),
                child: const Text('Address'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? idIssueDate =
                      _idIssueDateController.text.isNotEmpty
                          ? DateFormat('dd/MM/yyyy')
                              .parse(_idIssueDateController.text)
                          : null;

                  final DateTime? expirationDate =
                      _expirationDateController.text.isNotEmpty
                          ? DateFormat('dd/MM/yyyy')
                              .parse(_expirationDateController.text)
                          : null;
                  final result = await showDialog<Map<String, dynamic>>(
                    context: context,
                    builder: (BuildContext context) {
                      return IdentificationInformation(
                          initialIdNumberDriverLicense:
                              _idNumberDriverLicenseController.text,
                          initialIdIssueDate: idIssueDate,
                          initialExpirationDate: expirationDate,
                          initialForIDPurposes: _forIDPurposesController.text,
                          initialCreditCardExpirationDate:
                              _creditCardExpirationDateController.text);
                    },
                  );

                  if (result != null) {
                    DateTime issueDate = result['idIssueDate'];
                    String issueformattedDate =
                        DateFormat('dd/MM/yyyy').format(issueDate);
                    DateTime expirationDate = result['expirationDate'];
                    String expirationformattedDate =
                        DateFormat('dd/MM/yyyy').format(expirationDate);
                    _idIssueDate = issueDate;
                    _expirationDate = expirationDate;

                    _idNumberDriverLicenseController.text =
                        result['idNumberDriverLicense'];
                    _idIssueDateController.text = issueformattedDate;
                    _expirationDateController.text = expirationformattedDate;
                    _forIDPurposesController.text = result['forIDPurposes'];
                    _creditCardExpirationDateController.text =
                        result['creditCardExpirationDate'];
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueGrey, // color del botón
                  minimumSize: const Size(88, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                ),
                child: const Text('Identification'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final result = await showDialog<Map<String, dynamic>>(
                    context: context,
                    builder: (BuildContext context) {
                      return WorkInformation(
                        initialOccupation: _occupationController.text,
                        initialEmployerName: _employerNameController.text,
                        initialEmployerPhoneNumber:
                            _employerPhoneNumberController.text,
                        initialEmploymentMonthlyIncome:
                            _employmentMonthlyIncomeController.text,
                        initialOtherIncome: _otherIncomeController.text,
                        initialSourceOfOtherIncome:
                            _sourceOfOtherIncomeController.text,
                        initialTimeAtCurrentJob:
                            _timeAtCurrentJobController.text,
                      );
                    },
                  );

                  if (result != null) {
                    _employerNameController.text = result['employerName'];
                    _employerPhoneNumberController.text =
                        result['employerPhoneNumber'];
                    _occupationController.text = result['occupation'];
                    _timeAtCurrentJobController.text =
                        result['timeAtCurrentJob'];
                    _employmentMonthlyIncomeController.text =
                        result['employmentMonthlyIncome'];
                    _otherIncomeController.text = result['otherIncome'];
                    _sourceOfOtherIncomeController.text =
                        result['sourceOtherIncome'];
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueGrey, // color del botón
                  minimumSize: const Size(88, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                ),
                child: const Text('Work information'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final coApplicantData = {
                      'firstName': _applicantFirstNameController.text,
                      'lastName': _applicantLastNameController.text,
                      'phoneNumber': _phoneNumberController.text,
                      'email': _emailController.text,
                      'socialSecurityNumber':
                          _socialSecurityNumberController.text,
                      'idNumberDriverLicense':
                          _idNumberDriverLicenseController.text,
                      'address': _addressController.text,
                      'city': _cityController.text,
                      'state': _stateController.text,
                      'cityZipCode': _cityZipCodeController.text,
                      'timeAtResidence': _timeAtResidenceController.text,
                      'monthlyMortgagePayment':
                          _monthlyMortgagePaymentController.text,
                      'employerName': _employerNameController.text,
                      'employerPhoneNumber':
                          _employerPhoneNumberController.text,
                      'occupation': _occupationController.text,
                      'employmentMonthlyIncome':
                          _employmentMonthlyIncomeController.text,
                      'otherIncome': _otherIncomeController.text,
                      'sourceOfOtherIncome':
                          _sourceOfOtherIncomeController.text,
                      'timeAtCurrentJob': _timeAtCurrentJobController.text,
                      'dateOfBirth': _dateOfBirthController.text,
                      'idIssueDate': _idIssueDateController.text,
                      'expirationDate': _expirationDateController.text,
                      'forIDPurposes': _forIDPurposesController.text,
                      'creditCardExpirationDate':
                          _creditCardExpirationDateController.text,
                      // Agrega aquí más campos si son necesarios
                    };
                    Navigator.pop(context, coApplicantData);
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
