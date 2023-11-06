import 'package:flutter/material.dart';

class BankDetailsDialog extends StatefulWidget {
  final Function(String, String, String, String) onSubmit;

  const BankDetailsDialog({super.key, required this.onSubmit});

  @override
  _BankDetailsDialogState createState() => _BankDetailsDialogState();
}

class _BankDetailsDialogState extends State<BankDetailsDialog> {
  final _formKey = GlobalKey<FormState>();
  final _bankNameController = TextEditingController();
  final _accountHolderController = TextEditingController();
  final _routingNumberController = TextEditingController();
  final _accountNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enrrol in Autopay'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _bankNameController,
                decoration: const InputDecoration(labelText: 'Bank Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the bank name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _accountHolderController,
                decoration: const InputDecoration(labelText: 'Account Holder'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the account holder name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _routingNumberController,
                decoration: const InputDecoration(labelText: 'Routing Number'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the routing number';
                  }
                  // You can add more validations for routing number format here.
                  return null;
                },
              ),
              TextFormField(
                controller: _accountNumberController,
                decoration: const InputDecoration(labelText: 'Account Number'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the account number';
                  }
                  // You can add more validations for account number format here.
                  return null;
                },
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
          child: const Text('Submit'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSubmit(
                _bankNameController.text,
                _accountHolderController.text,
                _routingNumberController.text,
                _accountNumberController.text,
              );
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _bankNameController.dispose();
    _accountHolderController.dispose();
    _routingNumberController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }
}
