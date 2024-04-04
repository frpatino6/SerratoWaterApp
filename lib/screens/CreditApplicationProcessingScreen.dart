import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:serrato_water_app/bloc/sales_list/sales_bloc.dart';
import 'package:serrato_water_app/bloc/sales_list/sales_event.dart';
import 'package:serrato_water_app/models/sales_data.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
  List<dynamic> _images = [null, null, null];
  bool _isUploading = false;
  bool _isEditable = true;
  bool _isLoadingImages = true;

  @override
  void initState() {
    super.initState();
    _isEditable = widget.saleData.applicationState == "Pending Installation";

    if (!_isEditable) {
      _loadUploadedImages();
    } else {
      _isLoadingImages = false; // No estás cargando imágenes si es editable.
    }
  }

  Future<void> _pickImage(int index) async {
    if (!_isEditable) return;
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _images[index] = File(image.path);
      });
    }
  }

  Future<void> _loadUploadedImages() async {
    int loadedImages = 0;
    for (var i = 0; i < _images.length; i++) {
      String filePath = 'credit_applications/${widget.saleData.id}/$i.jpg';
      final ref = FirebaseStorage.instance.ref(filePath);
      ref.getDownloadURL().then((url) {
        setState(() {
          _images[i] = url;
          loadedImages++;
          // Verifica si todas las imágenes se han cargado o no se encontraron.
          if (loadedImages == _images.length) {
            _isLoadingImages = false;
          }
        });
      }).catchError((e) {
        loadedImages++;
        // Asume que si hay un error, la imagen simplemente no está disponible.
        if (loadedImages == _images.length) {
          setState(() {
            _isLoadingImages = false;
          });
        }
      });
    }

    // Si no hay imágenes para cargar, asegúrate de desactivar el indicador de carga.
    if (_images.every((image) => image == null)) {
      setState(() {
        _isLoadingImages = false;
      });
    }
  }

  void _showUploadDialog() async {
    if (!_isEditable) return;
    final shouldUpload = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upload Images'),
        content: const Text('Are you sure you want to upload the images?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (shouldUpload == true) {
      _uploadImagesAndUpdatState();
    }
  }

  Future<void> _uploadImagesAndUpdatState() async {
    if (!_isEditable) return;
    setState(() {
      _isUploading = true;
    });

    bool uploadSuccess = true;
    try {
      for (var i = 0; i < _images.length; i++) {
        if (_images[i] != null && _images[i] is File) {
          String filePath = 'credit_applications/${widget.saleData.id}/$i.jpg';
          await FirebaseStorage.instance.ref(filePath).putFile(_images[i]);
        }
      }
    } catch (e) {
      uploadSuccess = false;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to upload images: $e')));
    }

    if (uploadSuccess) {
      _updateApplicationState();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Images uploaded successfully and application status updated')));
    }

    setState(() {
      _isUploading = false;
    });

    if (uploadSuccess) {
      Navigator.pop(context, widget.saleData.applicationState);
    }
  }

  void _updateApplicationState() {
    final salesBloc = BlocProvider.of<SalesBloc>(context);
    salesBloc.add(UpdateSalesStatusEvent(widget.saleData.id, "Installed"));
    widget.saleData.applicationState = "Installed";
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
        actions: _isEditable
            ? [
                IconButton(
                  icon: const Icon(Icons.cloud_upload),
                  onPressed: _isUploading ? null : _showUploadDialog,
                ),
              ]
            : [],
      ),
      body: _isLoadingImages
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: _isUploading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Address:', style: headingStyle),
                          Text(widget.saleData.address, style: contentStyle),
                          const SizedBox(height: 10),
                          Text('Applicant Name:', style: headingStyle),
                          Text(widget.saleData.applicantName,
                              style: contentStyle),
                          const SizedBox(height: 10),
                          Text('State:', style: headingStyle),
                          Text(widget.saleData.applicationState,
                              style: contentStyle),
                          const SizedBox(height: 20),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: _images.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () =>
                                    _isEditable ? _pickImage(index) : null,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: _images[index] != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: _images[index] is File
                                              ? Image.file(_images[index],
                                                  fit: BoxFit.cover)
                                              : Image.network(_images[index],
                                                  fit: BoxFit.cover),
                                        )
                                      : const Icon(Icons.add_a_photo,
                                          color: Colors.grey),
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
