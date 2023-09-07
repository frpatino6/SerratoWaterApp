import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serrato_water_app/bloc/credit_application/credit_application_bloc.dart';
import 'package:serrato_water_app/bloc/credit_application/credit_application_event.dart';
import 'package:serrato_water_app/bloc/credit_application/credit_application_state.dart';
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

  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _idIssueDateController = TextEditingController();
  final TextEditingController _creditCardExpirationDateController =
      TextEditingController();
  final TextEditingController _expirationDateController =
      TextEditingController();

  String _saleAmount = '';
  String _hardness = '';
  String _salesRepresentative = '';
  String _productsSold = '';
  String _applicantName = '';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Credit Application'),
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
        ],
      ),
      body: BlocConsumer<CreditApplicationBloc, CreditApplicationState>(
        listener: (context, state) {
          if (state is CreditApplicationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          } else if (state is CreditApplicationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Application saved successfully!')),
            );
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
                    decoration:
                        const InputDecoration(labelText: 'Sale Amount (\$)'),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onSaved: (value) => _saleAmount = value!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Hardness'),
                    onSaved: (value) => _hardness = value!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Sales Representative'),
                    onSaved: (value) => _salesRepresentative = value!,
                  ),
                  DropdownButtonFormField<String>(
                    decoration:
                        const InputDecoration(labelText: 'Products Sold'),
                    value: _selectedProduct,
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
                    decoration:
                        const InputDecoration(labelText: 'Applicant Name'),
                    onSaved: (value) => _applicantName = value!,
                  ),
                  TextFormField(
                    controller: _dateOfBirthController,
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
                    decoration: const InputDecoration(
                        labelText: 'Phone Number (US Format)',
                        prefixText: '+1 '),
                    keyboardType: TextInputType.phone,
                    onSaved: (value) => _phoneNumber = value!,
                  ),
                  TextFormField(
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
                    decoration: const InputDecoration(
                        labelText: 'Social Security Number'),
                    onSaved: (value) => _socialSecurityNumber = value!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'ID Number (Driver License)'),
                    onSaved: (value) => _idNumberDriverLicense = value!,
                  ),
                  TextFormField(
                    controller: _idIssueDateController,
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
                    decoration: const InputDecoration(
                        labelText: 'Time at Residence (in months)'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _timeAtResidence = int.parse(value!),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Address'),
                    onSaved: (value) => _address = value!,
                  ),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(labelText: 'State'),
                    items: _statesList.map((String value) {
                      return new DropdownMenuItem<String>(
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
                    decoration:
                        const InputDecoration(labelText: 'City (Zip Code)'),
                    onSaved: (value) => _cityZipCode = value!,
                  ),
                  DropdownButtonFormField(
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
                    decoration: const InputDecoration(
                        labelText: 'Monthly Mortgage Payment (\$)'),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onSaved: (value) => _monthlyMortgagePayment = value!,
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Employer Name'),
                    onSaved: (value) => _employerName = value!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Employer Phone Number', prefixText: '+1 '),
                    keyboardType: TextInputType.phone,
                    onSaved: (value) => _employerPhoneNumber = value!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Occupation'),
                    onSaved: (value) => _occupation = value!,
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Time at Current Job'),
                    onSaved: (value) => _timeAtCurrentJob = value!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Employment Monthly Income (\$)'),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onSaved: (value) => _employmentMonthlyIncome = value!,
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Other Income (\$)'),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onSaved: (value) => _otherIncome = value!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Source of Other Income'),
                    onSaved: (value) => _sourceOfOtherIncome = value!,
                  ),
                  DropdownButtonFormField(
                    decoration:
                        const InputDecoration(labelText: 'For ID purposes'),
                    items: _idPurposesList.map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
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
                      children: [const Text('Yes'), const Text('No')],
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
        "applicantName": _applicantName,
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
      };

      BlocProvider.of<CreditApplicationBloc>(context)
          .add(SaveCreditApplicationEvent(applicationData));
    }
  }

  void _handleMenuSelection(String choice) {
    if (choice == 'Mis Transacciones') {
      // Aquí puedes navegar a la pantalla de "Mis Transacciones" o realizar cualquier otra acción que necesites.
      Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const MisTransaccionesScreen()));
    }
  }
}
