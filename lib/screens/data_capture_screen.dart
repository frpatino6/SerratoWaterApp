import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:serrato_water_app/bloc/credit_application/credit_application_bloc.dart';
import 'package:serrato_water_app/bloc/credit_application/credit_application_event.dart';
import 'package:serrato_water_app/bloc/credit_application/credit_application_state.dart';
import 'package:serrato_water_app/providers/user_provider.dart';
import 'package:serrato_water_app/screens/auth_screen.dart';
import 'package:serrato_water_app/screens/mis_transacciones_screen.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';

class DataCaptureScreen extends StatefulWidget {
  const DataCaptureScreen({super.key});

  @override
  _DataCaptureScreenState createState() => _DataCaptureScreenState();
}

class _WatermarkPaint extends CustomPainter {
  final String price;
  final String watermark;

  _WatermarkPaint(this.price, this.watermark);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 10.8,
        Paint()..color = Colors.blue);
  }

  @override
  bool shouldRepaint(_WatermarkPaint oldDelegate) {
    return oldDelegate != this;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _WatermarkPaint &&
          runtimeType == other.runtimeType &&
          price == other.price &&
          watermark == other.watermark;

  @override
  int get hashCode => price.hashCode ^ watermark.hashCode;
}

class _DataCaptureScreenState extends State<DataCaptureScreen> {
  final _formKey = GlobalKey<FormState>();
  final _sign = GlobalKey<SignatureState>();
  late final String price;
  late final String watermark;

  TextEditingController _saleAmountController = TextEditingController();
  TextEditingController _hardnessController = TextEditingController();
  TextEditingController _salesRepresentativeController =
      TextEditingController();
  TextEditingController _productsSoldController = TextEditingController();
  TextEditingController _applicantFirstNameController = TextEditingController();
  TextEditingController _applicantLastNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _dateOfBirthController = TextEditingController();
  TextEditingController _idIssueDateController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _socialSecurityNumberController =
      TextEditingController();
  TextEditingController _idNumberDriverLicenseController =
      TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _cityZipCodeController = TextEditingController();
  TextEditingController _installationAddressDifferentController =
      TextEditingController();
  TextEditingController _expirationDateController = TextEditingController();
  TextEditingController _monthlyMortgagePaymentController =
      TextEditingController();
  TextEditingController _employerNameController = TextEditingController();
  TextEditingController _employerPhoneNumberController =
      TextEditingController();
  TextEditingController _occupationController = TextEditingController();
  TextEditingController _timeAtCurrentJobController = TextEditingController();
  TextEditingController _employmentMonthlyIncomeController =
      TextEditingController();
  TextEditingController _otherIncomeController = TextEditingController();
  TextEditingController _sourceOfOtherIncomeController =
      TextEditingController();
  TextEditingController _forIDPurposesController = TextEditingController();
  TextEditingController _creditCardExpirationDateController =
      TextEditingController();
  TextEditingController _userController = TextEditingController();
  TextEditingController _timeAtResidenceController = TextEditingController();

  String _saleAmount = '';
  String _hardness = '';
  String _salesRepresentative = '';
  String _productsSold = '';
  String _applicantFirstName = '';
  String _applicantLastName = '';
  DateTime _dateOfBirth = DateTime.now();
  String _phoneNumber = '';
  String _email = '';
  String _socialSecurityNumber = '';
  String _idNumberDriverLicense = '';
  DateTime _idIssueDate = DateTime.now();
  DateTime _expirationDate = DateTime.now();
  int _timeAtResidence = 0;
  String _address = '';
  String _state = '';
  String _cityZipCode = '';
  String _installationAddressDifferent = 'No';
  String _monthlyMortgagePayment = '';
  String _employerName = '';
  String _employerPhoneNumber = '';
  String _occupation = '';
  String _timeAtCurrentJob = '';
  String _employmentMonthlyIncome = '';
  String _otherIncome = '';
  String _sourceOfOtherIncome = '';
  String _forIDPurposes = 'VISA';
  String _creditCardExpirationDate = '';
  bool _isACHInfoAdded = false;
  bool _isIncomeNoticeChecked = false;
  bool _isCoApplicantAdded = false;
  String _user = "";
  FilePickerResult? _file;
  final List<String> _products = [
    "",
    "Hydronex 30C",
    "Well Water System",
    "MM7000",
    "Alkaline Stage",
    "5 Years soaps"
  ];
  String? _selectedProduct;
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

  final List<String> _idPurposesList = [
    "VISA",
    "MASTERCARD",
    "AMERICAN EXPRESS",
    "DINERS"
  ];

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<UserProvider>(context).username;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Credit Application'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const AuthScreen()),
            );
          },
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(20.0),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Fill in the following form please',
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: _handleMenuSelection,
            itemBuilder: (BuildContext context) {
              return {'My transactions'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                _submitForm();
                // Aquí puedes procesar y guardar los datos del formulario.
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _clearFormFields();
            },
          ),
        ],
      ),
      body: BlocConsumer<CreditApplicationBloc, CreditApplicationState>(
        listener: (context, state) {
          if (state is CreditApplicationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          } else if (state is CreditApplicationSuccess) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Ok'),
                  content:
                      const Text('The application has been successfully saved'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
            _clearFormFields();
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    controller: _saleAmountController,
                    decoration:
                        const InputDecoration(labelText: 'Sale Amount (\$)'),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onSaved: (value) => _saleAmount = value!,
                    validator: (value) => customValidator(value,
                        isRequired: true, isCurrency: true, min: 0.01),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Hardness'),
                    controller: _hardnessController,
                    onSaved: (value) => _hardness = value!,
                    validator: (value) => customValidator(value,
                        isRequired: true, isNumeric: false),
                  ),
                  TextFormField(
                    controller: _salesRepresentativeController,
                    decoration: const InputDecoration(
                        labelText: 'Sales Representative'),
                    onSaved: (value) => _salesRepresentative = value!,
                    validator: (value) => customValidator(value,
                        isRequired: true, isNumeric: false),
                    // add validator
                  ),
                  DropdownButtonFormField<String>(
                    decoration:
                        const InputDecoration(labelText: 'Products Sold'),
                    value: _selectedProduct,
                    validator: (value) => customValidator(value,
                        isRequired: true, isNumeric: false),
                    items: _products.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedProduct = newValue;
                      });
                    },
                    onSaved: (value) {
                      _selectedProduct = value;
                    },
                  ),
                  TextFormField(
                    controller: _applicantFirstNameController,
                    decoration:
                        const InputDecoration(labelText: 'Applicant Firt Name'),
                    onSaved: (value) => _applicantFirstName = value!,
                    validator: (value) => customValidator(value,
                        isRequired: true, isNumeric: false),
                  ),
                  TextFormField(
                    controller: _applicantLastNameController,
                    decoration:
                        const InputDecoration(labelText: 'Applicant Last Name'),
                    onSaved: (value) => _applicantLastName = value!,
                    validator: (value) => customValidator(value,
                        isRequired: false, isNumeric: false),
                  ),
                  TextFormField(
                    controller: _dateOfBirthController,
                    validator: (value) => customValidator(value,
                        isRequired: true,
                        isDate: true,
                        minDate: DateTime(1900),
                        maxDate: DateTime.now()),
                    decoration:
                        const InputDecoration(labelText: 'Date of Birth'),
                    onTap: () async {
                      DateTime date = DateTime(1900);
                      FocusScope.of(context).requestFocus(new FocusNode());

                      date = (await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now())) ??
                          DateTime.now();
                      _dateOfBirth = date;
                      _dateOfBirthController.text =
                          date.toLocal().toString().split(' ')[0];
                    },
                  ),
                  TextFormField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(
                        labelText: 'Phone Number (US Format)',
                        prefixText: '+1 '),
                    keyboardType: TextInputType.phone,
                    validator: (value) => customValidator(value,
                        isRequired: true, isNumeric: false),
                    onSaved: (value) => _phoneNumber = value!,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null ||
                          !RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onSaved: (value) => _email = value!,
                  ),
                  TextFormField(
                    controller: _socialSecurityNumberController,
                    decoration: const InputDecoration(
                        labelText: 'Social Security Number'),
                    onSaved: (value) => _socialSecurityNumber = value!,
                    validator: (value) => customValidator(value,
                        isRequired: true, isNumeric: true),
                  ),
                  TextFormField(
                    controller: _idNumberDriverLicenseController,
                    decoration: const InputDecoration(
                        labelText: 'ID Number (Driver License)'),
                    onSaved: (value) => _idNumberDriverLicense = value!,
                    validator: (value) => customValidator(value,
                        isRequired: true, isNumeric: false),
                  ),
                  TextFormField(
                    controller: _idIssueDateController,
                    validator: (value) => customValidator(value,
                        isRequired: true,
                        isDate: true,
                        minDate: DateTime(1900),
                        maxDate: DateTime.now()),
                    decoration:
                        const InputDecoration(labelText: 'ID Issue Date'),
                    onTap: () async {
                      DateTime date = DateTime(1900);
                      FocusScope.of(context).requestFocus(new FocusNode());

                      date = (await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now())) ??
                          DateTime.now();
                      _idIssueDate = date;
                      _idIssueDateController.text =
                          date.toLocal().toString().split(' ')[0];
                    },
                  ),
                  TextFormField(
                    controller: _expirationDateController,
                    validator: (value) => customValidator(value,
                        isRequired: true,
                        isDate: true,
                        minDate: DateTime(1900),
                        maxDate: DateTime.now()),
                    decoration:
                        const InputDecoration(labelText: 'Expiration Date'),
                    onTap: () async {
                      DateTime date = DateTime(1900);
                      FocusScope.of(context).requestFocus(new FocusNode());

                      date = (await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now())) ??
                          DateTime.now();
                      _expirationDate = date;
                      _expirationDateController.text =
                          date.toLocal().toString().split(' ')[0];
                    },
                  ),
                  TextFormField(
                    controller: _timeAtResidenceController,
                    decoration: const InputDecoration(
                        labelText: 'Time at Residence (in months)'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _timeAtResidence = int.parse(value!),
                    validator: (value) => customValidator(value,
                        isRequired: true, isNumeric: false),
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                    onSaved: (value) => _address = value!,
                  ),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(labelText: 'State'),
                    value:
                        _state.isEmpty ? null : _state, // Asigna el valor aquí
                    items: _statesList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _state = newValue.toString();
                      });
                    },
                    onSaved: (value) => _state = value!,
                  ),
                  TextFormField(
                    controller: _cityZipCodeController,
                    decoration:
                        const InputDecoration(labelText: 'City (Zip Code)'),
                    onSaved: (value) => _cityZipCode = value!,
                  ),
                  DropdownButtonFormField(
                    value: _state.isEmpty
                        ? null
                        : _installationAddressDifferent, // Asigna el valor aquí
                    decoration: const InputDecoration(
                        labelText: 'Is the installation address different?'),
                    items: <String>['Yes', 'No']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _installationAddressDifferent = newValue!;
                      });
                    },
                    onSaved: (value) => _installationAddressDifferent = value!,
                  ),
                  TextFormField(
                    controller: _monthlyMortgagePaymentController,
                    decoration: const InputDecoration(
                        labelText: 'Monthly Mortgage Payment (\$)'),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onSaved: (value) => _monthlyMortgagePayment = value!,
                    validator: (value) => customValidator(value,
                        isRequired: true, isCurrency: true, min: 0.01),
                  ),
                  TextFormField(
                    controller: _employerNameController,
                    decoration:
                        const InputDecoration(labelText: 'Employer Name'),
                    onSaved: (value) => _employerName = value!,
                    validator: (value) => customValidator(value,
                        isRequired: true, isNumeric: false),
                  ),
                  TextFormField(
                    controller: _employerPhoneNumberController,
                    decoration: const InputDecoration(
                        labelText: 'Employer Phone Number', prefixText: '+1 '),
                    keyboardType: TextInputType.phone,
                    onSaved: (value) => _employerPhoneNumber = value!,
                    validator: (value) => customValidator(value,
                        isRequired: true, isNumeric: false),
                  ),
                  TextFormField(
                    controller: _occupationController,
                    decoration: const InputDecoration(labelText: 'Occupation'),
                    onSaved: (value) => _occupation = value!,
                    validator: (value) => customValidator(value,
                        isRequired: true, isNumeric: false),
                  ),
                  TextFormField(
                    controller: _timeAtCurrentJobController,
                    decoration:
                        const InputDecoration(labelText: 'Time at Current Job'),
                    onSaved: (value) => _timeAtCurrentJob = value!,
                    validator: (value) => customValidator(value,
                        isRequired: true, isNumeric: false),
                  ),
                  TextFormField(
                    controller: _employmentMonthlyIncomeController,
                    decoration: const InputDecoration(
                        labelText: 'Employment Monthly Income (\$)'),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onSaved: (value) => _employmentMonthlyIncome = value!,
                    validator: (value) => customValidator(value,
                        isRequired: true, isCurrency: true, min: 0.01),
                  ),
                  TextFormField(
                    controller: _otherIncomeController,
                    decoration:
                        const InputDecoration(labelText: 'Other Income (\$)'),
                    validator: (value) => customValidator(value,
                        isRequired: true, isCurrency: true, min: 0.01),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onSaved: (value) => _otherIncome = value!,
                  ),
                  TextFormField(
                    controller: _sourceOfOtherIncomeController,
                    decoration: const InputDecoration(
                        labelText: 'Source of Other Income'),
                    onSaved: (value) => _sourceOfOtherIncome = value!,
                    validator: (value) => customValidator(value,
                        isRequired: true, isNumeric: false),
                  ),
                  DropdownButtonFormField(
                    value: _state.isEmpty
                        ? null
                        : _forIDPurposes, // Asigna el valor aquí
                    decoration:
                        const InputDecoration(labelText: 'For ID purposes'),
                    items: _idPurposesList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    validator: (value) => customValidator(value,
                        isRequired: true, isNumeric: false),
                    onChanged: (newValue) {
                      setState(() {
                        _forIDPurposes = newValue.toString();
                      });
                    },
                    onSaved: (value) => _forIDPurposes = value!,
                  ),
                  TextFormField(
                    controller: _creditCardExpirationDateController,
                    decoration: const InputDecoration(
                        labelText: 'Credit Card Expiration Date (MM/YY)'),
                    keyboardType: TextInputType.datetime,
                    validator: (value) {
                      if (value == null ||
                          !RegExp(r"^(0[1-9]|1[0-2])\/([0-9]{2})$")
                              .hasMatch(value)) {
                        return 'Please enter a valid date in MM/YY format';
                      }
                      return null;
                    },
                    onSaved: (value) => _creditCardExpirationDate = value!,
                  ),
                  ListTile(
                    title: const Text('Add ACH Info?'),
                    trailing: ToggleButtons(
                      children: const [Text('Yes'), Text('No')],
                      isSelected: [_isACHInfoAdded, !_isACHInfoAdded],
                      onPressed: (int index) {
                        setState(() {
                          _isACHInfoAdded = index == 0;
                        });
                      },
                    ),
                  ),

                  // Nuevo campo: File Upload
                  ElevatedButton(
                    onPressed: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles();

                      if (result != null) {
                        setState(() {
                          _file = result;
                        });
                      }
                    },
                    child: const Text('Upload File'),
                  ),

                  // Nuevo campo: Signature
                  // Signature(
                  //   color: Colors.red,
                  //   key: _sign,
                  //   onSign: () {
                  //     final sign = _sign.currentState;
                  //   },
                  //   backgroundPainter: _WatermarkPaint("2.0", "2.0"),
                  //   strokeWidth: 5.0,
                  // ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Date'),
                    // ... Agrega un validador y selector de fecha aquí,
                  ),

                  ListTile(
                    title: const Text('Do you want to add Co-Applicant?'),
                    trailing: ToggleButtons(
                      children: const [Text('Yes'), Text('No')],
                      isSelected: [_isCoApplicantAdded, !_isCoApplicantAdded],
                      onPressed: (int index) {
                        setState(() {
                          _isCoApplicantAdded = index == 0;
                        });
                      },
                    ),
                  ),
                  CheckboxListTile(
                    title: const Text('INCOME NOTICE: *'),
                    value: _isIncomeNoticeChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        _isIncomeNoticeChecked = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final applicationData = {
        "saleAmount": _saleAmount,
        "hardness": _hardness,
        "salesRepresentative": _salesRepresentative,
        "productsSold": _productsSold,
        "applicantName": _applicantFirstName,
        "dateOfBirth": _dateOfBirth.toIso8601String(),
        "phoneNumber": _phoneNumber,
        "email": _email,
        "socialSecurityNumber": _socialSecurityNumber,
        "idNumberDriverLicense": _idNumberDriverLicense,
        "idIssueDate": _idIssueDate.toIso8601String(),
        "expirationDate": _expirationDate.toIso8601String(),
        "timeAtResidence": _timeAtResidence,
        "address": _address,
        "state": _state,
        "cityZipCode": _cityZipCode,
        "installationAddressDifferent": _installationAddressDifferent,
        "monthlyMortgagePayment": _monthlyMortgagePayment,
        "employerName": _employerName,
        "employerPhoneNumber": _employerPhoneNumber,
        "occupation": _occupation,
        "timeAtCurrentJob": _timeAtCurrentJob,
        "employmentMonthlyIncome": _employmentMonthlyIncome,
        "otherIncome": _otherIncome,
        "sourceOfOtherIncome": _sourceOfOtherIncome,
        "forIDPurposes": _forIDPurposes,
        "creditCardExpirationDate": _creditCardExpirationDate,
        "isACHInfoAdded": _isACHInfoAdded,
        "isIncomeNoticeChecked": _isIncomeNoticeChecked,
        "isCoApplicantAdded": _isCoApplicantAdded,
        "selectedProduct": _selectedProduct,
        "userOwner": _user,
      };

      BlocProvider.of<CreditApplicationBloc>(context)
          .add(SaveCreditApplicationEvent(applicationData));
    }
  }

  void _handleMenuSelection(String choice) {
    if (choice == 'My transactions') {
      // Aquí puedes navegar a la pantalla de "Mis Transacciones" o realizar cualquier otra acción que necesites.
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => MisTransaccionesScreen()));
    }
  }

  String? customValidator(String? value,
      {bool isRequired = true,
      bool isNumeric = false,
      bool isDate = false,
      DateTime? minDate,
      DateTime? maxDate,
      bool isCurrency = false,
      double? min,
      double? max}) {
    if (isRequired && (value == null || value.isEmpty)) {
      return 'This field is required';
    }

    if (isNumeric && double.tryParse(value ?? '') == null) {
      return 'Please enter a valid number';
    }

    if (isDate) {
      DateTime? date = DateTime.tryParse(value ?? '');
      if (date == null) {
        return 'Please enter a valid date';
      } else if (minDate != null && date.isBefore(minDate)) {
        return 'The date cannot be earlier than ${minDate.toLocal().toString().split(' ')[0]}';
      } else if (maxDate != null && date.isAfter(maxDate)) {
        return 'The date cannot be later than ${maxDate.toLocal().toString().split(' ')[0]}';
      }
    }
    if (isCurrency) {
      double? amount = double.tryParse(value ?? '');
      if (amount == null) {
        return 'Please enter a valid amount';
      } else if (min != null && amount < min) {
        return 'The amount cannot be less than \$${min.toString()}';
      } else if (max != null && amount > max) {
        return 'The amount cannot be more than \$${max.toString()}';
      }
    }
    return null;
  }

  void _clearFormFields() {
    _saleAmountController.clear();
    _hardnessController.clear();
    _salesRepresentativeController.clear();
    _productsSoldController.clear();
    _applicantFirstNameController.clear();
    _applicantLastNameController.clear();
    _phoneNumberController.clear();
    _emailController.clear();
    _socialSecurityNumberController.clear();
    _idNumberDriverLicenseController.clear();
    _addressController.clear();
    _stateController.clear();
    _cityZipCodeController.clear();
    _installationAddressDifferentController.clear();
    _monthlyMortgagePaymentController.clear();
    _employerNameController.clear();
    _employerPhoneNumberController.clear();
    _occupationController.clear();
    _timeAtCurrentJobController.clear();
    _employmentMonthlyIncomeController.clear();
    _otherIncomeController.clear();
    _sourceOfOtherIncomeController.clear();
    _forIDPurposesController.clear();
    _creditCardExpirationDateController.clear();
    _userController.clear();

    setState(() {
      _dateOfBirth = DateTime.now();
      _idIssueDate = DateTime.now();
      _expirationDate = DateTime.now();
      _timeAtResidence = 0;
      _isACHInfoAdded = false;
      _isIncomeNoticeChecked = false;
      _isCoApplicantAdded = false;
    });
  }
}
