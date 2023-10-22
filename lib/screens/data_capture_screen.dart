// ignore_for_file: unused_field

import 'dart:ui' as ui;

// ignore: unused_import
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
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
import 'package:serrato_water_app/widgets/identification_information.dart';
import 'package:serrato_water_app/widgets/personal_information.dart';
import 'package:serrato_water_app/widgets/products_sale.dart';
import 'package:serrato_water_app/widgets/work_information.dart';

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
  late MaskedTextController _creditCardExpirationDateController;
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _timeAtResidenceController =
      TextEditingController();

  String _saleAmount = '';
  final String _hardness = '';
  final String _salesRepresentative = '';
  final String _productsSold = '';
  DateTime _dateOfBirth = DateTime.now();
  DateTime _idIssueDate = DateTime.now();
  DateTime _expirationDate = DateTime.now();
  int _timeAtResidence = 0;
  final String _address = '';
  final String _state = '';
  final String _cityZipCode = '';
  bool _installationAddressDifferent = false;

  final String _employerName = '';
  final String _employerPhoneNumber = '';
  final String _occupation = '';
  final String _timeAtCurrentJob = '';
  final String _employmentMonthlyIncome = '';
  final String _otherIncome = '';
  final String _sourceOfOtherIncome = '';
  String _forIDPurposes = '';

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
  final String _city = '';

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
  final bool _isChequed = false;

  final List<String> _idPurposesList = [
    "VISA",
    "MASTERCARD",
    "AMERICAN EXPRESS",
    "DISCOVER",
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
                  ElevatedButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return ProductsDialog(
                            onSubmit: (selectedProducts, cost) {
                              // Aquí, `selectedProducts` es una lista de productos seleccionados,
                              // y `cost` es el valor ingresado para el costo.
                              // Puedes proceder con estos datos como necesites.
                              _selectedProducts = selectedProducts;
                              _saleAmountController.text = cost;
                            },
                          );
                        },
                      );
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
                    child: const Text('Products Sale'),
                  ),
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
                    child: const Text('Personal Information'),
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
                        _timeAtResidenceController.text =
                            result['timeAtResidence'];
                        _monthlyMortgagePaymentController.text =
                            result['monthlyMortgagePayment'];
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
                      final result = await showDialog<Map<String, dynamic>>(
                        context: context,
                        builder: (BuildContext context) {
                          return const IdentificationInformation();
                        },
                      );

                      if (result != null) {
                        _idNumberDriverLicenseController.text =
                            result['idNumberDriverLicense'];
                        _idIssueDateController.text =
                            result['idIssueDate'].toString();
                        _expirationDateController.text =
                            result['expirationDate'].toString();
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
                          return const WorkInformation();
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
                  ListTile(
                    title: const Text('Is the installation address different?'),
                    trailing: ToggleButtons(
                      isSelected: [_isCoApplicantAdded, !_isCoApplicantAdded],
                      onPressed: (int index) {
                        setState(() {
                          _installationAddressDifferent = index == 0;
                        });

                        if (_installationAddressDifferent) {
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
                      children: const [Text('Yes'), Text('No')],
                    ),
                  ),
                  ListTile(
                    title: const Text('Enroll in AutoPay?'),
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
        "monthlyMortgagePayment": _monthlyMortgagePaymentController.text,
        "employerName": _employerName,
        "employerPhoneNumber": _employerPhoneNumber,
        "occupation": _occupation,
        "timeAtCurrentJob": _timeAtCurrentJob,
        "employmentMonthlyIncome": _employmentMonthlyIncome,
        "otherIncome": _otherIncome,
        "sourceOfOtherIncome": _sourceOfOtherIncome,
        "forIDPurposes": _forIDPurposes,
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
