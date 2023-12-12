import 'package:flutter/material.dart';

class CoApplicantForm extends StatefulWidget {
  const CoApplicantForm({super.key});

  @override
  _CoApplicantFormState createState() => _CoApplicantFormState();
}

class _CoApplicantFormState extends State<CoApplicantForm> {
  final _formKey = GlobalKey<FormState>();
  // Define las variables necesarias para tu formulario aquí

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Co-Applicant Form'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            // Tus campos de formulario van aquí
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Recoger los datos del formulario
                  Navigator.pop(
                    context, /* Datos del formulario */
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
