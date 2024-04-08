import 'dart:typed_data';

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
      _isLoadingImages = false;
    }
  }

  Future<void> _pickImage(int index) async {
    if (!_isEditable) return;
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _images[index] = image;
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
          if (loadedImages == _images.length) {
            _isLoadingImages = false;
          }
        });
      }).catchError((e) {
        loadedImages++;
        if (loadedImages == _images.length) {
          setState(() {
            _isLoadingImages = false;
          });
        }
      });
    }

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
      _uploadImagesAndUpdateState();
    }
  }

  Future<void> _uploadImagesAndUpdateState() async {
    if (!_isEditable) return;
    setState(() {
      _isUploading = true;
    });

    bool uploadSuccess = true;
    try {
      for (var i = 0; i < _images.length; i++) {
        if (_images[i] != null && _images[i] is XFile) {
          String filePath = 'credit_applications/${widget.saleData.id}/$i.jpg';
          var fileBytes = await (_images[i] as XFile).readAsBytes();
          await FirebaseStorage.instance.ref(filePath).putData(fileBytes);
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
                                          child: _images[index] is XFile
                                              ? FutureBuilder<Uint8List>(
                                                  future:
                                                      (_images[index] as XFile)
                                                          .readAsBytes(),
                                                  builder: (BuildContext
                                                          context,
                                                      AsyncSnapshot<Uint8List>
                                                          snapshot) {
                                                    if (snapshot.connectionState ==
                                                            ConnectionState
                                                                .done &&
                                                        snapshot.data != null) {
                                                      return Image.memory(
                                                          snapshot.data!,
                                                          fit: BoxFit.cover);
                                                    } else if (snapshot.error !=
                                                        null) {
                                                      return const Icon(
                                                          Icons.error,
                                                          color: Colors.red);
                                                    } else {
                                                      return const CircularProgressIndicator();
                                                    }
                                                  },
                                                )
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
