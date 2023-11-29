import 'package:flutter/material.dart';

class WorkInformation extends StatefulWidget {
  final String initialOccupation;
  final String initialEmployerName;
  final String initialEmployerPhoneNumber;
  final String initialEmploymentMonthlyIncome;
  final String initialOtherIncome;
  final String initialSourceOfOtherIncome;
  final String initialTimeAtCurrentJob;

  const WorkInformation({
    Key? key,
    this.initialOccupation = '',
    this.initialEmployerName = '',
    this.initialEmployerPhoneNumber = '',
    this.initialEmploymentMonthlyIncome = '',
    this.initialOtherIncome = '',
    this.initialSourceOfOtherIncome = '',
    this.initialTimeAtCurrentJob = '',
  }) : super(key: key);

  @override
  _WorkInformationState createState() => _WorkInformationState();
}

class _WorkInformationState extends State<WorkInformation> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _occupationController = TextEditingController();
  TextEditingController _employerNameController = TextEditingController();
  TextEditingController _employerPhoneNumberController =
      TextEditingController();
  TextEditingController _employmentMonthlyIncomeController =
      TextEditingController();
  TextEditingController _otherIncomeController = TextEditingController();
  TextEditingController _sourceOfOtherIncomeController =
      TextEditingController();
  TextEditingController _timeAtCurrentJobController = TextEditingController();

  // Variables para guardar los valores cuando se guarda el formulario
  String _occupation = '';
  String _employerName = '';
  String _employerPhoneNumber = '';
  String _employmentMonthlyIncome = '';
  String _otherIncome = '';
  String _sourceOfOtherIncome = '';
  String _timeAtCurrentJob = '';

  @override
  void initState() {
    super.initState();
    _occupationController =
        TextEditingController(text: widget.initialOccupation);
    _employerNameController =
        TextEditingController(text: widget.initialEmployerName);
    _employerPhoneNumberController =
        TextEditingController(text: widget.initialEmployerPhoneNumber);
    _employmentMonthlyIncomeController =
        TextEditingController(text: widget.initialEmploymentMonthlyIncome);
    _otherIncomeController =
        TextEditingController(text: widget.initialOtherIncome);
    _sourceOfOtherIncomeController =
        TextEditingController(text: widget.initialSourceOfOtherIncome);
    _timeAtCurrentJobController =
        TextEditingController(text: widget.initialTimeAtCurrentJob);
  }

  // Un método de validación genérico que puedes personalizar según tus necesidades
  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    // Agrega más lógica de validación si es necesario
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Creamos un mapa con los datos recopilados del formulario
      Map<String, dynamic> formData = {
        "occupation": _occupation,
        "employerName": _employerName,
        "employerPhoneNumber": _employerPhoneNumber,
        "employmentMonthlyIncome": _employmentMonthlyIncome,
        "otherIncome": _otherIncome,
        "sourceOtherIncome": _sourceOfOtherIncome,
        "timeAtCurrentJob": _timeAtCurrentJob,
      };

      // Utilizamos Navigator.pop para cerrar el diálogo y pasar de vuelta el mapa de datos
      Navigator.of(context).pop(formData);
    }
  }

  @override
  void dispose() {
    // Limpieza de los controladores cuando el widget se deshaga
    _occupationController.dispose();
    _employerNameController.dispose();
    _employerPhoneNumberController.dispose();
    _employmentMonthlyIncomeController.dispose();
    _otherIncomeController.dispose();
    _sourceOfOtherIncomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Work Information'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _occupationController,
                decoration: const InputDecoration(labelText: 'Occupation'),
                validator: _validateInput,
                onSaved: (value) => _occupation = value!,
              ),
              TextFormField(
                controller: _employerNameController,
                decoration: const InputDecoration(labelText: 'Employer Name'),
                validator: _validateInput,
                onSaved: (value) => _employerName = value!,
              ),
              TextFormField(
                controller: _timeAtCurrentJobController,
                decoration:
                    const InputDecoration(labelText: 'Time at Current Job'),
                onSaved: (value) => _timeAtCurrentJob = value!,
                keyboardType: TextInputType.number,
                validator: _validateInput,
              ),
              TextFormField(
                controller: _employerPhoneNumberController,
                decoration: const InputDecoration(
                    labelText: 'Employer Phone Number', prefixText: '+1 '),
                keyboardType: TextInputType.phone,
                validator: _validateInput,
                onSaved: (value) => _employerPhoneNumber = value!,
              ),
              TextFormField(
                controller: _employmentMonthlyIncomeController,
                decoration: const InputDecoration(
                    labelText: 'Employment Monthly Income (\$)'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: _validateInput,
                onSaved: (value) => _employmentMonthlyIncome = value!,
              ),
              TextFormField(
                controller: _otherIncomeController,
                decoration:
                    const InputDecoration(labelText: 'Other Income (\$)'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: _validateInput,
                onSaved: (value) => _otherIncome = value!,
              ),
              TextFormField(
                controller: _sourceOfOtherIncomeController,
                decoration:
                    const InputDecoration(labelText: 'Source of Other Income'),
                validator: _validateInput,
                onSaved: (value) => _sourceOfOtherIncome = value!,
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          onPressed: _submitForm,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
