import 'package:flutter/material.dart';

class AddressDialog extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final List<String> stateList;
  final Function onSave;
  final String initialState;

  const AddressDialog(
      {Key? key,
      required this.formKey,
      required this.stateList,
      required this.onSave,
      required this.initialState})
      : super(key: key);

  @override
  _AddressDialogState createState() => _AddressDialogState();
}

class _AddressDialogState extends State<AddressDialog> {
  String? installationAddress;
  String? city;
  String? selectedState;
  String? zipCode;

  @override
  void initState() {
    super.initState();
    selectedState = widget.initialState;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: widget.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Installation Address',
              ),
              onSaved: (value) {
                installationAddress = value;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'City',
              ),
              onSaved: (value) {
                city = value;
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
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Zip Code',
              ),
              onSaved: (value) {
                zipCode = value;
              },
            ),
          ],
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
              widget.onSave(installationAddress, city, selectedState, zipCode);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
