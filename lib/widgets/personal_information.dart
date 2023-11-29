import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PersonalInformationDialog extends StatefulWidget {
  final String initialFirstName;
  final String initialLastName;
  final DateTime? initialDateOfBirth;
  final String initialPhoneNumber;
  final String initialEmail;
  final String initialSocialSecurityNumber;

  const PersonalInformationDialog({
    super.key,
    required this.initialFirstName,
    required this.initialLastName,
    required this.initialDateOfBirth,
    required this.initialPhoneNumber,
    required this.initialEmail,
    required this.initialSocialSecurityNumber,
  });

  @override
  _PersonalInformationDialogState createState() =>
      _PersonalInformationDialogState();
}

class _PersonalInformationDialogState extends State<PersonalInformationDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _applicantFirstNameController = TextEditingController();
  TextEditingController _applicantLastNameController = TextEditingController();
  TextEditingController _dateOfBirthController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _socialSecurityNumberController =
      TextEditingController();
  DateTime? _dateOfBirth = DateTime.now();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Map<String, dynamic> formData = {
        'firstName': _applicantFirstNameController.text,
        'lastName': _applicantLastNameController.text,
        'dateOfBirth': _dateOfBirth,
        'phoneNumber': _phoneNumberController.text,
        'email': _emailController.text,
        'socialSecurityNumber': _socialSecurityNumberController.text,
      };

      Navigator.of(context).pop(formData);
    }
  }

  @override
  void dispose() {
    _applicantFirstNameController.dispose();
    _applicantLastNameController.dispose();
    _dateOfBirthController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _socialSecurityNumberController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _applicantFirstNameController =
        TextEditingController(text: widget.initialFirstName);
    _applicantLastNameController =
        TextEditingController(text: widget.initialLastName);
    _dateOfBirthController = TextEditingController(
        text: widget.initialDateOfBirth != null
            ? DateFormat('dd/MM/yyyy').format(widget.initialDateOfBirth!)
            : '');
    _phoneNumberController =
        TextEditingController(text: widget.initialPhoneNumber);
    _emailController = TextEditingController(text: widget.initialEmail);
    _socialSecurityNumberController =
        TextEditingController(text: widget.initialSocialSecurityNumber);

    _dateOfBirth = widget.initialDateOfBirth;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Personal Information'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _applicantFirstNameController,
                decoration:
                    const InputDecoration(labelText: 'Applicant First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _applicantLastNameController,
                decoration:
                    const InputDecoration(labelText: 'Applicant Last Name'),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateOfBirthController,
                decoration: const InputDecoration(labelText: 'Date of Birth'),
                readOnly: true,
                onTap: () async {
                  final DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );

                  if (selectedDate != null && selectedDate != _dateOfBirth) {
                    setState(() {
                      _dateOfBirth = selectedDate;
                      _dateOfBirthController.text =
                          selectedDate.toLocal().toString().split(' ')[0];
                    });
                  }
                },
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                    labelText: 'Phone Number (US Format)', prefixText: '+1 '),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
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
              TextFormField(
                controller: _socialSecurityNumberController,
                decoration:
                    const InputDecoration(labelText: 'Social Security Number'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your social security number';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context), // This closes the dialog
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
