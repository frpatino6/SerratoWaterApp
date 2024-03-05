import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serrato_water_app/bloc/credit_application/credit_application_bloc.dart';
import 'package:serrato_water_app/bloc/credit_application/credit_application_event.dart';
import 'package:serrato_water_app/bloc/credit_application/credit_application_state.dart';
import 'package:serrato_water_app/widgets/products_sale.dart';

class SingleDataCaptureScreen extends StatefulWidget {
  final String userName;
  const SingleDataCaptureScreen({Key? key, required this.userName})
      : super(key: key);

  @override
  _SingleDataCaptureScreenState createState() =>
      _SingleDataCaptureScreenState();
}

class _SingleDataCaptureScreenState extends State<SingleDataCaptureScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _saleAmountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  List<String> _selectedProducts = [];

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Single Data Capture'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_rounded),
            onPressed: _submitForm,
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
                        Navigator.of(context).pop(); // Cierra el AlertDialog
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        },
        builder: (context, state) {
          if (state is CreditApplicationLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return ProductsDialog(
                            initialSelectedProducts: _selectedProducts,
                            initialCost: _saleAmountController.text,
                            onSubmit: (selectedProducts, cost) {
                              setState(() {
                                _selectedProducts = selectedProducts;
                                _saleAmountController.text = cost;
                              });
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
                    child: const Text('Products'),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8, // Espacio entre los Chips
                    children: _selectedProducts
                        .map((product) => Chip(
                              label: Text(product),
                              backgroundColor: Colors.blue,
                              labelStyle: const TextStyle(color: Colors.white),
                              deleteIcon:
                                  const Icon(Icons.close, color: Colors.white),
                              onDeleted: () {
                                setState(() {
                                  _selectedProducts.remove(product);
                                });
                              },
                            ))
                        .toList(),
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter a name'
                        : null,
                  ),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter a last name'
                        : null,
                  ),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                        labelText: 'Phone Number (US Format)',
                        prefixText: '+1 '),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter an address'
                        : null,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null ||
                          !RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
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
        "address": _addressController.text,
        "email": _emailController.text,
        "productsSold": _selectedProducts.join(", "),
        "userOwner": widget.userName,
        "date": DateTime.now().toIso8601String(),
        "saleAmount": _saleAmountController.text,
        "salesRepresentative": widget.userName,
        "applicantName": "${_nameController.text} ${_lastNameController.text}",
        "dateOfBirth": DateTime(0).toIso8601String(),
        "phoneNumber": _phoneController.text,
        "socialSecurityNumber": '',
        "idNumberDriverLicense": "",
        "idIssueDate": DateTime(0).toIso8601String(),
        "expirationDate": DateTime(0).toIso8601String(),
        "cityZipCode": "",
        "installationAddressDifferent": false,
        "monthlyMortgagePayment": "",
        "employerName": "",
        "employerPhoneNumber": "",
        "occupation": "",
        "timeAtCurrentJob": "",
        "employmentMonthlyIncome": "",
        "otherIncome": "",
        "sourceOfOtherIncome": "",
        "forIDPurposes": "",
        "isACHInfoAdded": false,
        "isIncomeNoticeChecked": false,
        "isCoApplicantAdded": false,
        "installationAddress": "",
        "installationCity": "",
        "installationState": "",
        "installationZipCode": "",
        "bankName": "",
        "accountHolder": "",
        "routingNumber": "",
        "accountNumber": "",
        "city": "",
        "state": "",
        "applicationState": "Submitted",
        "creditCardExpirationDate": "",
        "timeAtResidence": 0,
        "coApplicantName": "",
        "coApplicantDOB": "",
        "coApplicantPhoneNumber": "",
      };

      BlocProvider.of<CreditApplicationBloc>(context)
          .add(SaveCreditApplicationEvent(applicationData));
    }
  }

  void _selectProducts() {
    // Implement the logic to select products here
    // Update the _selectedProducts list accordingly
  }
}
