import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:serrato_water_app/api/fireBaseApi.dart';
import 'package:serrato_water_app/bloc/auth/auth_bloc.dart';
import 'package:serrato_water_app/bloc/auth/auth_event.dart';
import 'package:serrato_water_app/bloc/profile/profile_bloc.dart';
import 'package:serrato_water_app/bloc/profile/profile_event.dart';
import 'package:serrato_water_app/bloc/profile/profile_state.dart';
import 'package:serrato_water_app/screens/auth_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;
  final String userType;
  ProfileScreen({Key? key, required this.userName, required this.userType})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController surnameController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController addressController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController guidController = TextEditingController();

  final TextEditingController companyAddressController =
      TextEditingController();

  final TextEditingController companyPhoneController = TextEditingController();

  final TextEditingController einController = TextEditingController();

  final TextEditingController companyNameController = TextEditingController();

  final TextEditingController firstKeyController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  Key imageKey = UniqueKey();
  XFile? pickedFile;
  String? _imageUrl;
  XFile? _imageFile;

  Future<void> _pickImageFromCamera() async {
    pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth:
          1024, // Define el ancho máximo para reducir el tamaño de la imagen
      maxHeight:
          768, // Define la altura máxima para reducir el tamaño de la imagen
      imageQuality:
          60, // Ajusta la calidad de la imagen (0-100), siendo 100 la máxima calidad
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
        imageKey = UniqueKey();
      });
    }
  }

  Future<void> uploadImage(BuildContext context) async {
    if (pickedFile != null) {
      File imageFile = File(pickedFile!.path);
      try {
        // Sube la imagen a Firebase Storage
        await FirebaseStorage.instance
            .ref('profile_images/${widget.userName}.jpg')
            .putFile(imageFile);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image uploaded successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected')),
      );
    }
  }

  Future<void> loadImageFromFirebaseStorage() async {
    try {
      final ref =
          FirebaseStorage.instance.ref('profile_images/${widget.userName}.jpg');

      final String imageUrl = await ref.getDownloadURL();

      setState(() {
        _imageUrl = imageUrl;
        _imageFile = null;
      });
    } catch (e) {
      // Maneja el error de alguna manera, por ejemplo, mostrando un mensaje al usuario
    }
  }

  Widget _buildImage() {
    Widget imageWidget;

    // Decide el widget de imagen basado en la fuente disponible
    if (_imageUrl != null) {
      imageWidget = Image.network(_imageUrl!, fit: BoxFit.cover);
    } else if (_imageFile != null) {
      imageWidget = Image.file(File(_imageFile!.path), fit: BoxFit.cover);
    } else {
      // Un placeholder en caso de que no haya imagen disponible
      imageWidget = const Text('No image selected');
    }

    // Retorna la imagen dentro de un contenedor con estilo
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            'License of Transit',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: imageWidget,
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    loadImageFromFirebaseStorage();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(FirebaseAPI()),
      child: Builder(
        builder: (context) {
          context.read<ProfileBloc>().add(LoadUserProfile(widget.userName));

          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: _pickImageFromCamera,
                ),
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    if (BlocProvider.of<ProfileBloc>(context).state
                        is! ProfileLoading) {
                      // Verifica si se ha seleccionado una imagen
                      if (_imageFile == null) {
                        // Muestra un AlertDialog si no hay imagen seleccionada
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Missing Image'),
                              content: const Text(
                                  'Please, upload the transit license image before saving.'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Cierra el AlertDialog
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // Procede con la actualización del perfil y la carga de la imagen
                        context.read<ProfileBloc>().add(
                              UpdateUserProfile(
                                guidController.text,
                                nameController.text,
                                surnameController.text,
                                phoneController.text,
                                addressController.text,
                                emailController.text,
                                widget.userType == 'Dealer'
                                    ? companyNameController.text
                                    : "",
                                widget.userType == 'Dealer'
                                    ? companyAddressController.text
                                    : "",
                                widget.userType == 'Dealer'
                                    ? companyPhoneController.text
                                    : "",
                                widget.userType == 'Dealer'
                                    ? einController.text
                                    : "",
                                1,
                                widget.userType,
                                firstKeyController.text,
                              ),
                            );
                        uploadImage(context);
                      }
                    }
                  },
                ),
                IconButton(
                    icon: const Icon(Icons.logout_sharp),
                    onPressed: () async {
                      BlocProvider.of<AuthBloc>(context).add(LogoutEvent());

                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('isLoggedIn', false);
                      if (context.mounted) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (_) => const AuthScreen()));
                      }
                    })
              ],
            ),
            body: Container(
              padding: const EdgeInsets.all(16.0),
              child: BlocConsumer<ProfileBloc, ProfileState>(
                listener: (context, state) {
                  if (state is UserProfileUpdated) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        const SnackBar(
                            content: Text('Profile updated successfully')),
                      );
                  } else if (state is ProfileError) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                  }
                },
                builder: (context, state) {
                  if (state is ProfileLoading || state is UserProfileUpdating) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is UserProfileLoaded) {
                    nameController.text =
                        state.userProfile["user"]['firstName'] ?? '';
                    surnameController.text =
                        state.userProfile["user"]['lastName'] ?? '';
                    phoneController.text =
                        state.userProfile["user"]['phone'].toString();
                    addressController.text =
                        state.userProfile["user"]['address'];
                    emailController.text = state.userProfile["user"]['email'];
                    companyNameController.text =
                        state.userProfile["user"]['company_name'] ?? '';
                    companyAddressController.text =
                        state.userProfile["user"]['company_address'] ?? '';
                    companyPhoneController.text =
                        state.userProfile["user"]['company_phone'] ?? '';
                    einController.text = state.userProfile["user"]['ein'] ?? '';
                    firstKeyController.text =
                        state.userProfile['firstKey'] ?? '';
                  }
                  if (widget.userType == 'Dealer') {
                    return ListView(
                      children: [
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                          readOnly: true,
                        ),
                        TextFormField(
                          controller: companyNameController,
                          decoration:
                              const InputDecoration(labelText: 'Company Name'),
                          readOnly: true,
                        ),
                        TextFormField(
                          controller: companyAddressController,
                          decoration: const InputDecoration(
                              labelText: 'Company Address'),
                        ),
                        TextFormField(
                          controller: companyPhoneController,
                          decoration: const InputDecoration(
                              labelText: 'Company Phone Number'),
                        ),
                        TextFormField(
                          controller: einController,
                          decoration: const InputDecoration(labelText: 'EIN'),
                        ),
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(labelText: 'Name'),
                        ),
                        TextFormField(
                          controller: surnameController,
                          decoration:
                              const InputDecoration(labelText: 'Last Name'),
                        ),
                        TextFormField(
                          controller: phoneController,
                          decoration: const InputDecoration(labelText: 'Phone'),
                        ),
                        TextFormField(
                          controller: addressController,
                          decoration:
                              const InputDecoration(labelText: 'Address'),
                        ),
                        const SizedBox(height: 20),
                        _buildImage(),
                      ],
                    );
                  } else {
                    return ListView(
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(labelText: 'Name'),
                        ),
                        TextFormField(
                          controller: surnameController,
                          decoration:
                              const InputDecoration(labelText: 'Last Name'),
                        ),
                        TextFormField(
                          controller: phoneController,
                          decoration: const InputDecoration(labelText: 'Phone'),
                        ),
                        TextFormField(
                          controller: addressController,
                          decoration:
                              const InputDecoration(labelText: 'Address'),
                        ),
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                          readOnly: true,
                        ),
                        const SizedBox(height: 20),
                        _buildImage(),
                      ],
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? '';
  }
}
