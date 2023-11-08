import 'package:flutter/material.dart';

class CoApplicantDialog extends StatefulWidget {
  final List<String> stateList;
  final List<String> idPurposesList;
  final GlobalKey<FormState> formKey;
  final String initialState;
  final String initialIDPurpose;
  final Function onSave;
  final Function customValidator;

  const CoApplicantDialog(
      {super.key,
      required this.formKey,
      required this.stateList,
      required this.onSave,
      required this.initialState,
      required this.idPurposesList,
      required this.initialIDPurpose,
      required this.customValidator});

  @override
  State<CoApplicantDialog> createState() => _CoApplicantDialogState();
}

class _CoApplicantDialogState extends State<CoApplicantDialog> {
  @override
  void initState() {
    super.initState();
    selectedState = widget.initialState;
    selectedIDPurpose = widget.initialIDPurpose;
  }

  // Controladores para cada campo
  final _coApplicantNameController = TextEditingController();

  final _coApplicantDOBController = TextEditingController();

  final _coApplicantPhoneNumberController = TextEditingController();

  final _coApplicantEmailController = TextEditingController();

  final _coApplicantSSNController = TextEditingController();

  final _coApplicantIDNumberController = TextEditingController();

  final _expirationDateController = TextEditingController();

  final _residenceDurationController = TextEditingController();

  final _addressController = TextEditingController();

  final _cityController = TextEditingController();

  final _zipCodeController = TextEditingController();

  final _mortgagePaymentController = TextEditingController();

  final _employerNameController = TextEditingController();

  final _employerPhoneNumberController = TextEditingController();

  final _occupationController = TextEditingController();

  final _jobDurationController = TextEditingController();

  final _monthlyIncomeController = TextEditingController();

  final _otherIncomeController = TextEditingController();

  final _otherIncomeSourceController = TextEditingController();

  final _creditCardExpirationController = TextEditingController();

  String? selectedState;
  String? selectedIDPurpose;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: widget.formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _coApplicantNameController,
                validator: (value) => widget.customValidator(value,
                    isRequired: true, isNumeric: false),
                decoration:
                    const InputDecoration(labelText: 'Co - Applicant Name'),
              ),
              TextFormField(
                controller: _coApplicantDOBController,
                validator: (value) => widget.customValidator(value,
                    isRequired: true, isDate: true),
                decoration: const InputDecoration(
                    labelText: 'Co - Applicant Date of Birth'),
                readOnly:
                    true, // Esto evita que el usuario pueda escribir directamente en el campo
                onTap: () async {
                  // Se abre el DatePicker
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    // Formateamos la fecha seleccionada y la establecemos en el controller
                    String formattedDate =
                        "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                    _coApplicantDOBController.text = formattedDate;
                  }
                },
                onSaved: (value) {
                  _coApplicantDOBController.text = value!;
                },
              ),
              TextFormField(
                controller: _coApplicantPhoneNumberController,
                validator: (value) => widget.customValidator(value,
                    isRequired: true, isNumeric: false),
                decoration: const InputDecoration(
                    labelText: 'Co - Applicant Phone Number',
                    prefixText: '+1 '),
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: _coApplicantEmailController,
                decoration:
                    const InputDecoration(labelText: 'Co - Applicant Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null ||
                      !RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onSaved: (value) {
                  _coApplicantEmailController.text = value!;
                },
              ),
              TextFormField(
                controller: _coApplicantSSNController,
                decoration: const InputDecoration(
                    labelText: 'Co - Applicant Social Security Number'),
                keyboardType: TextInputType.number,
                validator: (value) => widget.customValidator(value,
                    isRequired: true, isNumeric: true),
                onSaved: (value) {
                  _coApplicantSSNController.text = value!;
                },
              ),
              TextFormField(
                controller: _coApplicantIDNumberController,
                decoration: const InputDecoration(
                    labelText: "Co - Applicant ID Number (Driver's Licence)"),
                keyboardType: TextInputType.number,
                validator: (value) => widget.customValidator(value,
                    isRequired: true, isNumeric: true),
                onSaved: (value) {
                  _coApplicantIDNumberController.text = value!;
                },
              ),
              TextFormField(
                controller: _expirationDateController,
                decoration: const InputDecoration(labelText: 'Expiration Date'),
                validator: (value) => widget.customValidator(value,
                    isRequired: true, isDate: true),
                readOnly:
                    true, // Esto evita que el usuario pueda escribir directamente en el campo
                onTap: () async {
                  // Se abre el DatePicker
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime.now(), // La fecha inicial es el día actual
                    lastDate: DateTime.now().add(const Duration(
                        days: 365 *
                            10)), // Por ejemplo, permitimos seleccionar hasta 10 años en el futuro
                  );

                  if (pickedDate != null) {
                    // Formateamos la fecha seleccionada y la establecemos en el controller
                    String formattedDate =
                        "${pickedDate.month}-${pickedDate.year}"; // Solo mostramos mes y año para fechas de vencimiento
                    _expirationDateController.text = formattedDate;
                  }
                },
                onSaved: (value) {
                  _expirationDateController.text = value!;
                },
              ),
              TextFormField(
                controller: _residenceDurationController,
                keyboardType: TextInputType.number,
                validator: (value) =>
                    widget.customValidator(value, isRequired: true),
                decoration: const InputDecoration(
                    labelText: 'Co - Applicant Time at Residence'),
                onSaved: (value) {
                  _residenceDurationController.text = value!;
                },
              ),
              TextFormField(
                controller: _addressController,
                validator: (value) =>
                    widget.customValidator(value, isRequired: true),
                decoration: const InputDecoration(
                    labelText: 'Co - Applicant Address - Address Line 1'),
                onSaved: (value) {
                  _addressController.text = value!;
                },
              ),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'City zip code'),
                onSaved: (value) {
                  _cityController.text = value!;
                },
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'State'),
                value: selectedState!.isEmpty
                    ? null
                    : selectedState, // Asigna el valor aquí
                items: widget.stateList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedState = newValue.toString();
                  });
                },
                onSaved: (value) => selectedState = value!,
              ),
              TextFormField(
                controller: _zipCodeController,
                decoration: const InputDecoration(labelText: 'Zip Code'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _zipCodeController.text = value!;
                },
              ),
              TextFormField(
                controller: _mortgagePaymentController,
                validator: (value) => widget.customValidator(value,
                    isRequired: true, isCurrency: true),
                decoration: const InputDecoration(
                    labelText: 'Co - Applicant Monthly Mortgage Payment'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _mortgagePaymentController.text = value!;
                },
              ),
              TextFormField(
                controller: _employerNameController,
                validator: (value) =>
                    widget.customValidator(value, isRequired: true),
                decoration: const InputDecoration(
                    labelText: 'Co - Applicant Employer Name'),
                onSaved: (value) {
                  _employerNameController.text = value!;
                },
              ),
              TextFormField(
                controller: _employerPhoneNumberController,
                validator: (value) =>
                    widget.customValidator(value, isRequired: true),
                decoration: const InputDecoration(
                    labelText: 'Co - Applicant Employer Phone Number'),
                keyboardType: TextInputType.phone,
                onSaved: (value) {
                  _employerPhoneNumberController.text = value!;
                },
              ),
              TextFormField(
                controller: _occupationController,
                validator: (value) =>
                    widget.customValidator(value, isRequired: true),
                decoration: const InputDecoration(
                    labelText: 'Co - Applicant Occupation'),
                onSaved: (value) {
                  _occupationController.text = value!;
                },
              ),
              TextFormField(
                controller: _jobDurationController,
                keyboardType: TextInputType.number,
                validator: (value) => widget.customValidator(value,
                    isRequired: true, isNumeric: true),
                decoration: const InputDecoration(
                    labelText: 'Co - Applicant Time at Current Job'),
                onSaved: (value) {
                  _jobDurationController.text = value!;
                },
              ),
              TextFormField(
                controller: _monthlyIncomeController,
                validator: (value) => widget.customValidator(value,
                    isRequired: true, isCurrency: true),
                decoration: const InputDecoration(
                    labelText: 'Co - Applicant Employment Monthly Income'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _monthlyIncomeController.text = value!;
                },
              ),
              TextFormField(
                controller: _otherIncomeController,
                validator: (value) => widget.customValidator(value,
                    isRequired: true, isCurrency: true),
                decoration: const InputDecoration(
                    labelText: 'Co - Applicant Other Income'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _otherIncomeController.text = value!;
                },
              ),
              TextFormField(
                controller: _otherIncomeSourceController,
                decoration: const InputDecoration(
                    labelText: 'Co - Applicant Source of Other Income'),
                onSaved: (value) {
                  _otherIncomeSourceController.text = value!;
                },
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                    labelText: 'Co - Applicant For ID purposes'),
                value: selectedIDPurpose!.isEmpty
                    ? null
                    : selectedIDPurpose, // Asigna el valor aquí
                items: widget.idPurposesList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedIDPurpose = newValue.toString();
                  });
                },
                validator: (value) => widget.customValidator(value,
                    isRequired: true, isNumeric: false),
                onSaved: (value) => selectedIDPurpose = value!,
              ),
              TextFormField(
                controller: _creditCardExpirationController,
                decoration: const InputDecoration(
                    labelText: 'Co - Applicant Credit Card Expiration Date'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Submit'),
          onPressed: () {
            if (widget.formKey.currentState!.validate()) {
              widget.formKey.currentState!.save();
              widget.onSave(
                  _coApplicantNameController.text,
                  _coApplicantDOBController.text,
                  _coApplicantPhoneNumberController.text,
                  _coApplicantEmailController.text,
                  _coApplicantSSNController.text,
                  _coApplicantIDNumberController.text,
                  _expirationDateController.text,
                  _residenceDurationController.text,
                  _addressController.text,
                  _cityController.text,
                  selectedState!,
                  _zipCodeController.text,
                  _mortgagePaymentController.text,
                  _employerNameController.text,
                  _employerPhoneNumberController.text,
                  _occupationController.text,
                  _jobDurationController.text,
                  _monthlyIncomeController.text,
                  _otherIncomeController.text,
                  _otherIncomeSourceController.text,
                  selectedIDPurpose!,
                  _creditCardExpirationController.text);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
