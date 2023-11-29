import 'package:flutter/material.dart';

class AddressInformation extends StatefulWidget {
  final List<String> stateList;
  final String initialAddress;
  final String initialCity;
  final String initialState;
  final String initialCityZipCode;
  final String initialMonthlyMortgagePayment;
  final String initialTimeAtResidence;

  const AddressInformation({
    Key? key,
    required this.stateList,
    required this.initialAddress,
    required this.initialCity,
    required this.initialState,
    required this.initialCityZipCode,
    required this.initialMonthlyMortgagePayment,
    required this.initialTimeAtResidence,
  }) : super(key: key);

  @override
  _AddressInformationState createState() => _AddressInformationState();
}

class _AddressInformationState extends State<AddressInformation> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _cityZipCodeController = TextEditingController();
  TextEditingController _monthlyMortgagePaymentController =
      TextEditingController();
  TextEditingController _timeAtResidenceController = TextEditingController();

  String _address = '';
  String _city = '';
  String _state = '';
  String _cityZipCode = '';
  String _monthlyMortgagePayment = '';
  int _timeAtResidence = 0;

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _cityZipCodeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: widget.initialAddress);
    _cityController = TextEditingController(text: widget.initialCity);
    _cityZipCodeController =
        TextEditingController(text: widget.initialCityZipCode);
    _monthlyMortgagePaymentController =
        TextEditingController(text: widget.initialMonthlyMortgagePayment);
    _timeAtResidenceController =
        TextEditingController(text: widget.initialTimeAtResidence);
    _state = widget.initialState;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Preparar los datos a devolver
      Map<String, dynamic> formData = {
        'address': _address,
        'city': _city,
        'state': _state,
        'zipCode': _cityZipCode,
        'monthlyMortgagePayment': _monthlyMortgagePayment,
        'timeAtResidence': _timeAtResidence,
      };

      // Devolver los datos y cerrar el diálogo
      Navigator.of(context).pop(formData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Address Information'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                onSaved: (value) => _address = value!,
              ),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'City'),
                onSaved: (value) => _city = value!,
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'State'),
                value: _state == '' ? null : _state,
                items: widget.stateList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
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
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'City (Zip Code)'),
                onSaved: (value) => _cityZipCode = value!,
              ),
              TextFormField(
                controller: _monthlyMortgagePaymentController,
                decoration: const InputDecoration(
                    labelText: 'Monthly Mortgage Payment (\$)'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onSaved: (value) => _monthlyMortgagePayment = value!,
              ),
              TextFormField(
                controller: _timeAtResidenceController,
                decoration: const InputDecoration(
                    labelText: 'Time at Residence (in months)'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _timeAtResidence = int.parse(value!),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _submitForm,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
