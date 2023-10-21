// ignore_for_file: unused_field

import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:serrato_water_app/bloc/credit_application/credit_application_bloc.dart';
import 'package:serrato_water_app/bloc/credit_application/credit_application_event.dart';
import 'package:serrato_water_app/bloc/credit_application/credit_application_state.dart';
import 'package:serrato_water_app/providers/user_provider.dart';
import 'package:serrato_water_app/screens/auth_screen.dart';
import 'package:serrato_water_app/screens/mis_transacciones_screen.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:serrato_water_app/widgets/addres_information.dart';
import 'package:serrato_water_app/widgets/address_dialog.dart';
import 'package:serrato_water_app/widgets/co_application_dialog.dart';
import 'package:serrato_water_app/widgets/personal_information.dart';

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
  final _coApplicantFormKey = GlobalKey<FormState>();
  final _sign = GlobalKey<SignatureState>();
  late final String price;
  late final String watermark;

  final TextEditingController _saleAmountController = TextEditingController();

  final TextEditingController _productsSoldController = TextEditingController();
  final TextEditingController _applicantFirstNameController =
      TextEditingController();
  final TextEditingController _applicantLastNameController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _idIssueDateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _socialSecurityNumberController =
      TextEditingController();
  final TextEditingController _idNumberDriverLicenseController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityZipCodeController = TextEditingController();
  final TextEditingController _installationAddressDifferentController =
      TextEditingController();
  final TextEditingController _expirationDateController =
      TextEditingController();

  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _monthlyMortgagePaymentController =
      TextEditingController();
  final TextEditingController _employerNameController = TextEditingController();
  final TextEditingController _employerPhoneNumberController =
      TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _timeAtCurrentJobController =
      TextEditingController();
  final TextEditingController _employmentMonthlyIncomeController =
      TextEditingController();
  final TextEditingController _otherIncomeController = TextEditingController();
  final TextEditingController _sourceOfOtherIncomeController =
      TextEditingController();
  final TextEditingController _forIDPurposesController =
      TextEditingController();
  final TextEditingController _creditCardExpirationDateController =
      TextEditingController();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _timeAtResidenceController =
      TextEditingController();

  String _saleAmount = '';
  final String _hardness = '';
  final String _salesRepresentative = '';
  final String _productsSold = '';
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
  String _forIDPurposes = '';
  String _creditCardExpirationDate = '';
  bool _isACHInfoAdded = false;
  bool _isIncomeNoticeChecked = false;
  bool _isCoApplicantAdded = false;
  String _installationAddress = '';
  String _installationCity = '';
  String _installationState = '';
  String _user = "";
  String _installationZipCode = '';
  String _coApplicantName = '';
  String _coApplicantDOB = '';
  String _coApplicantPhoneNumber = '';
  String _coApplicantEmail = '';
  String _coApplicantSSN = '';
  String _coApplicantIDNumber = '';
  String _coApplicantexpirationDate = '';
  String _coApplicantresidenceDuration = '';
  String _coApplicantaddress = '';
  String _coApplicantcity = '';
  String _coApplicantstate = '';
  String _coApplicantzipCode = '';
  String _coApplicantmortgagePayment = '';
  String _coApplicantemployerName = '';
  String _coApplicantemployerPhoneNumber = '';
  String _coApplicantoccupation = '';
  String _coApplicantjobDuration = '';
  String _coApplicantmonthlyIncome = '';
  String _coApplicantotherIncome = '';
  String _coApplicantotherIncomeSource = '';
  String _coApplicantidPurpose = '';
  String _coApplicantcreditCardExpiration = '';
  String _city = '';
  FilePickerResult? _file;
  final List<String> _products = [
    "Hydronex 30C",
    "Well Water System",
    "MM7000",
    "Alkaline Stage",
    "5 Years soaps"
  ];
  List<String?> _selectedProducts = [];
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
  bool _isChequed = false;

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
                  MultiSelectBottomSheetField<String?>(
                    initialChildSize: 0.4,
                    maxChildSize: 1.0,
                    listType: MultiSelectListType.LIST,
                    searchable: true,
                    buttonText: const Text('Select Products'),
                    title: const Text('Products'),
                    items: _products
                        .map((product) =>
                            MultiSelectItem<String?>(product, product))
                        .toList(),
                    onConfirm: (List<String?> values) {
                      setState(() {
                        _selectedProducts =
                            values.map((String? value) => value!).toList();
                      });
                    },
                    chipDisplay: MultiSelectChipDisplay(
                      onTap: (value) {
                        setState(() {
                          _selectedProducts.remove(value);
                        });
                      },
                    ),
                  ),
                  // add ElevationButtom
                  ElevatedButton(
                    onPressed: () async {
                      final result = await showDialog<Map<String, dynamic>>(
                        context: context,
                        builder: (BuildContext context) =>
                            const PersonalInformationDialog(),
                      );

                      if (result != null) {
                        _applicantFirstNameController.text =
                            result['firstName'];
                        _applicantLastNameController.text = result['lastName'];
                        _dateOfBirthController.text = result['dateOfBirth'];
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
                    child: const Text('Open Registration Form'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await showDialog<Map<String, dynamic>>(
                        context: context,
                        builder: (BuildContext context) {
                          return const AddressInformation();
                        },
                      );

                      if (result != null) {
                        _addressController.text = result['address'];
                        _cityController.text = result['city'];
                        _stateController.text = result['state'];
                        _cityZipCodeController.text = result['zipCode'];
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
                    child: const Text('Open Address Form'),
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
                      FocusScope.of(context).requestFocus(FocusNode());

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
                      FocusScope.of(context).requestFocus(FocusNode());

                      date = (await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100))) ??
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
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                        labelText: 'Is the installation address different?'),
                    value: _installationAddressDifferent.isEmpty
                        ? null
                        : _installationAddressDifferent, // Asigna el valor aquí
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

                      if (newValue == 'Yes') {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AddressDialog(
                              formKey: GlobalKey<FormState>(),
                              stateList:
                                  _statesList, // Aquí estamos pasando la lista de estados
                              onSave: handleSave,
                              initialState: _state,
                            );
                          },
                        );
                      }
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
                    title: const Text('Add autopayment?'),
                    trailing: ToggleButtons(
                      isSelected: [_isACHInfoAdded, !_isACHInfoAdded],
                      onPressed: (int index) {
                        setState(() {
                          _isACHInfoAdded = index == 0;
                        });
                      },
                      children: const [Text('Yes'), Text('No')],
                    ),
                  ),
                  const SizedBox(
                      height:
                          10), // Adds some spacing between button and label.
                  const Text('ID Picture',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal)),
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
                  const SizedBox(
                      height:
                          10), // Adds some spacing between button and label.
                  if (_file != null)
                    Text('File name: ${_file!.files.single.name}',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue)),
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

                  ListTile(
                    title: const Text('Do you want to add Co-Applicant?'),
                    trailing: ToggleButtons(
                      isSelected: [_isCoApplicantAdded, !_isCoApplicantAdded],
                      onPressed: (int index) {
                        setState(() {
                          _isCoApplicantAdded = index == 0;
                        });

                        if (_isCoApplicantAdded) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CoApplicantDialog(
                                formKey: _coApplicantFormKey,
                                idPurposesList: _idPurposesList,
                                stateList:
                                    _statesList, // Aquí estamos pasando la lista de estados
                                onSave: handleSaveIdPorpouse,
                                initialState: _state,
                                initialIDPurpose: _forIDPurposes,
                                customValidator: customValidator,
                              );
                            },
                          );
                        }
                      },
                      children: const [Text('Yes'), Text('No')],
                    ),
                  ),
                  CheckboxListTile(
                    title: const Text('INCOME NOTICE: *'),
                    value: _isIncomeNoticeChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        _isIncomeNoticeChecked = value!;
                        if (_isIncomeNoticeChecked) {
                          _showProfessionalDialog(context);
                        }
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

  void _showProfessionalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(20),
          contentPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: const Text(
            'Income Notice',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "You need not disclosure alimony, child support or separate maintenance income if you do not wish to have it considered as a basis for repaying this obligation.\n\nBy signing below, you certify that all information given on this application is true and complete. You also authorize us to confirm the information in this application and give out information about you or your account to credit reporting agencies and others who are allowed to receive it.\n\nYou authorize and instruct us to request and receive credit information about you from any credit report agency or third party. If we do not approve this application, you request and authorize us to provide this application and credit information to other finance source witch will consider it under their credit standards.\n\nYou grant the other finance sources the right to request a consumer credit report on you and authorize them to check your credit and employment history. This is also an authorization for Serrato Water to enter the premises in the address given in this application and install the whole house water conditioning system and reverse osmosis once this application is approved.\n\nInstallation and removal charges will occur in case of cancellation after system being installed.",
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void handleSave(
      String installationAddress, String city, String state, String zipCode) {
    // Aquí puedes manejar los datos ingresados en el diálogo.
    // Por ejemplo, podrías almacenarlos en variables de instancia de la clase:
    _installationAddress = installationAddress;
    _installationCity = city;
    _installationState = state;
    _installationZipCode = zipCode;

    // No olvides llamar a setState para actualizar la interfaz de usuario, si es necesario
    setState(() {});
  }

  void handleSaveIdPorpouse(
      coApplicantName,
      coApplicantDOB,
      coApplicantPhoneNumber,
      coApplicantEmail,
      coApplicantSSN,
      coApplicantIDNumber,
      coApplicantexpirationDate,
      coApplicantresidenceDuration,
      coApplicantaddress,
      coApplicantcity,
      coApplicantstate,
      coApplicantzipCode,
      coApplicantmortgagePayment,
      coApplicantemployerName,
      coApplicantemployerPhoneNumber,
      coApplicantoccupation,
      coApplicantjobDuration,
      coApplicantmonthlyIncome,
      coApplicantotherIncome,
      coApplicantotherIncomeSource,
      coApplicantidPurpose,
      coApplicantcreditCardExpiration) {
    _coApplicantName = coApplicantName;
    _coApplicantDOB = coApplicantDOB;
    _coApplicantPhoneNumber = coApplicantPhoneNumber;
    _coApplicantEmail = coApplicantEmail;
    _coApplicantSSN = coApplicantSSN;
    _coApplicantIDNumber = coApplicantIDNumber;
    _coApplicantexpirationDate = coApplicantexpirationDate;
    _coApplicantresidenceDuration = coApplicantresidenceDuration;
    _coApplicantaddress = coApplicantaddress;
    _coApplicantcity = coApplicantcity;
    _coApplicantstate = coApplicantstate;
    _coApplicantzipCode = coApplicantzipCode;
    _coApplicantmortgagePayment = coApplicantmortgagePayment;
    _coApplicantemployerName = coApplicantemployerName;
    _coApplicantemployerPhoneNumber = coApplicantemployerPhoneNumber;
    _coApplicantoccupation = coApplicantoccupation;
    _coApplicantjobDuration = coApplicantjobDuration;
    _coApplicantmonthlyIncome = coApplicantmonthlyIncome;
    _coApplicantotherIncome = coApplicantotherIncome;
    _coApplicantotherIncomeSource = coApplicantotherIncomeSource;
    _coApplicantidPurpose = coApplicantidPurpose;
    _coApplicantcreditCardExpiration = coApplicantcreditCardExpiration;

    // No olvides llamar a setState para actualizar la interfaz de usuario, si es necesario
    setState(() {});
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final applicationData = {
        "saleAmount": _saleAmountController.text,
        "salesRepresentative": _user,
        "productsSold": _selectedProducts.join(", "),
        "applicantName":
            "${_applicantFirstNameController.text} ${_applicantLastNameController.text}",
        "dateOfBirth": _dateOfBirth.toIso8601String(),
        "phoneNumber": _phoneNumberController.text,
        "email": _emailController.text,
        "socialSecurityNumber": _socialSecurityNumberController.text,
        "idNumberDriverLicense": _idNumberDriverLicenseController.text,
        "idIssueDate": _idIssueDate.toIso8601String(),
        "expirationDate": _expirationDate.toIso8601String(),
        "timeAtResidence": _timeAtResidence,
        "address": _addressController.text,
        "state": _state,
        "cityZipCode": _cityZipCodeController.text,
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
        "userOwner": _user,
        "installationAddress": _installationAddress,
        "installationCity": _installationCity,
        "installationState": _installationState,
        "installationZipCode": _installationZipCode,
        "date": DateTime.now()
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
