import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';

class IdentificationInformation extends StatefulWidget {
  final String initialIdNumberDriverLicense;
  final DateTime? initialIdIssueDate;
  final DateTime? initialExpirationDate;
  final String initialForIDPurposes;
  final String initialCreditCardExpirationDate;

  const IdentificationInformation({
    Key? key,
    required this.initialIdNumberDriverLicense,
    required this.initialIdIssueDate,
    required this.initialExpirationDate,
    required this.initialForIDPurposes,
    required this.initialCreditCardExpirationDate,
  }) : super(key: key);

  @override
  _IdentificationInformationState createState() =>
      _IdentificationInformationState();
}

class _IdentificationInformationState extends State<IdentificationInformation> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _idNumberDriverLicenseController =
      TextEditingController();
  TextEditingController _idIssueDateController = TextEditingController();
  TextEditingController _expirationDateController = TextEditingController();
  late MaskedTextController _creditCardExpirationDateController;
  FilePickerResult? _file;
  String _idNumberDriverLicense = '';
  DateTime? _idIssueDate;
  DateTime? _expirationDate;
  String _forIDPurposes = '';
  String _creditCardExpirationDate = '';

  final List<String> _idPurposesList = [
    "VISA",
    "MASTERCARD",
    "AMERICAN EXPRESS",
    "DISCOVER",
  ];

  @override
  void dispose() {
    _idNumberDriverLicenseController.dispose();
    _idIssueDateController.dispose();
    _expirationDateController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Preparar los datos para devolver
      Map<String, dynamic> formData = {
        'idNumberDriverLicense': _idNumberDriverLicense,
        'idIssueDate': _idIssueDate,
        'expirationDate': _expirationDate,
        'forIDPurposes': _forIDPurposes,
        'creditCardExpirationDate': _creditCardExpirationDate,
        'file': _file,
      };

      // Cerrar el diálogo y devolver los datos
      Navigator.of(context).pop(formData);
    }
  }

  @override
  void initState() {
    super.initState();
    _idNumberDriverLicenseController =
        TextEditingController(text: widget.initialIdNumberDriverLicense);

    _idIssueDateController = TextEditingController(
        text: widget.initialIdIssueDate != null
            ? DateFormat('dd/MM/yyyy').format(widget.initialIdIssueDate!)
            : '');

    _expirationDateController = TextEditingController(
        text: widget.initialExpirationDate != null
            ? DateFormat('dd/MM/yyyy').format(widget.initialExpirationDate!)
            : '');

    _creditCardExpirationDateController = MaskedTextController(
      mask: '00/00',
      text: widget.initialCreditCardExpirationDate,
    );
    _forIDPurposes = widget.initialForIDPurposes;
    _idIssueDate = widget.initialIdIssueDate;
    _expirationDate = widget.initialExpirationDate;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Identification Information'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _idNumberDriverLicenseController,
                decoration: const InputDecoration(
                    labelText: 'ID Number (Driver License)'),
                onSaved: (value) => _idNumberDriverLicense = value!,
                validator: (value) {
                  // Añade tu lógica de validación aquí (reemplaza este condicional si es necesario)
                  if (value == null || value.isEmpty) {
                    return 'Please enter an ID number.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _idIssueDateController,
                decoration: const InputDecoration(labelText: 'ID Issue Date'),
                onTap: () async {
                  DateTime date = DateTime(1900);
                  FocusScope.of(context).requestFocus(
                      FocusNode()); // para cerrar el teclado si está abierto

                  date = (await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      )) ??
                      DateTime.now();
                  _idIssueDate = date;
                  _idIssueDateController.text =
                      date.toLocal().toString().split(' ')[0];
                },
                validator: (value) {
                  // Añade tu lógica de validación aquí (reemplaza este condicional si es necesario)
                  if (value == null || value.isEmpty) {
                    return 'Please enter the issue date.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _expirationDateController,
                decoration: const InputDecoration(labelText: 'Expiration Date'),
                onTap: () async {
                  DateTime date = DateTime(1900);
                  FocusScope.of(context).requestFocus(
                      FocusNode()); // para cerrar el teclado si está abierto

                  date = (await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      )) ??
                      DateTime.now();
                  _expirationDate = date;
                  _expirationDateController.text =
                      date.toLocal().toString().split(' ')[0];
                },
                validator: (value) {
                  // Añade tu lógica de validación aquí (reemplaza este condicional si es necesario)
                  if (value == null || value.isEmpty) {
                    return 'Please enter the expiration date.';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField(
                value: _idPurposesList.contains(_forIDPurposes)
                    ? _forIDPurposes
                    : null,
                decoration: const InputDecoration(
                    labelText: 'Second Identification Method'),
                items: _idPurposesList.toSet().map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) {
                  // Añade tu lógica de validación aquí (reemplaza este condicional si es necesario)
                  if (value == null || value.isEmpty) {
                    return 'Please enter the expiration date.';
                  }
                  return null;
                },
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
                    labelText: 'Credit / Debit Expiration Date'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !RegExp(r'^\d{2}\/\d{2}$').hasMatch(value)) {
                    return 'Please enter a valid date in the format MM/YY';
                  }

                  return null;
                },
                onSaved: (value) => _creditCardExpirationDate = value!,
              ),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'ID Picture',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                ),
              ),
              // Nuevo campo: File Upload
              Container(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
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
              ),
              const SizedBox(
                  height: 10), // Adds some spacing between button and label.
              if (_file != null)
                Text('File name: ${_file!.files.single.name}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue)),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context)
                .pop(); // Cierra el AlertDialog sin guardar datos
          },
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
