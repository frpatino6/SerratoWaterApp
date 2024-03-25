import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:serrato_water_app/models/sales_data.dart';

class CreditApplicationProcessingScreen extends StatefulWidget {
  final SaleData saleData;

  const CreditApplicationProcessingScreen({Key? key, required this.saleData})
      : super(key: key);

  @override
  State<CreditApplicationProcessingScreen> createState() =>
      _CreditApplicationProcessingScreenState();
}

class _CreditApplicationProcessingScreenState
    extends State<CreditApplicationProcessingScreen> {
  List<File?> _images = [
    null,
    null,
    null
  ]; // Para almacenar las imágenes seleccionadas

  Future<void> _pickImage(int index) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _images[index] = File(
            image.path); // Actualiza la imagen en la posición correspondiente
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle headingStyle = const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.blueGrey,
    );
    TextStyle contentStyle = const TextStyle(
      fontSize: 16,
      color: Colors.black54,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Process Credit Application'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Cambiado para permitir desplazamiento
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Address:', style: headingStyle),
              Text(widget.saleData.address, style: contentStyle),
              const SizedBox(height: 10), // Espaciado entre elementos
              Text('Applicant Name:', style: headingStyle),
              Text(widget.saleData.applicantName, style: contentStyle),
              const SizedBox(height: 10),
              Text('State:', style: headingStyle),
              Text(widget.saleData.state, style: contentStyle),
              const SizedBox(height: 20), // Espaciado antes de las imágenes
              GridView.builder(
                shrinkWrap:
                    true, // Importante para GridView en SingleChildScrollView
                physics:
                    const NeverScrollableScrollPhysics(), // Deshabilita el desplazamiento del GridView
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _images.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => _pickImage(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _images[index] != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                _images[index]!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(
                              Icons.add_a_photo,
                              color: Colors.grey[800],
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
