import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serrato_water_app/api/fireBaseApi.dart';
import 'package:serrato_water_app/bloc/profile/profile_bloc.dart';
import 'package:serrato_water_app/bloc/profile/profile_event.dart';
import 'package:serrato_water_app/bloc/profile/profile_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController guidController = TextEditingController();
  final String userName;
  ProfileScreen({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(FirebaseAPI()),
      child: Builder(
        builder: (context) {
          context.read<ProfileBloc>().add(LoadUserProfile(userName));

          return Scaffold(
            appBar: AppBar(title: const Text('Profile')),
            body: Container(
              padding: const EdgeInsets.all(16.0),
              child: BlocConsumer<ProfileBloc, ProfileState>(
                listener: (context, state) {
                  if (state is UserProfileUpdated) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar() // Esconde cualquier SnackBar actual antes de mostrar uno nuevo
                      ..showSnackBar(
                        const SnackBar(
                            content: Text('Profile updated successfully')),
                      );
                    // Opcional: Si deseas recargar la página o realizar alguna acción después de la actualización
                    // context.read<ProfileBloc>().add(LoadUserProfile(userName));
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
                    nameController.text = state.userProfile['firstName'];
                    surnameController.text = state.userProfile['lastName'];
                    phoneController.text =
                        state.userProfile['phone'].toString();
                    addressController.text = state.userProfile['address'];
                    emailController.text = state.userProfile['email'];
                  }

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
                        decoration: const InputDecoration(labelText: 'Address'),
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        readOnly: true,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (state is! ProfileLoading) {
                            context.read<ProfileBloc>().add(
                                  UpdateUserProfile(
                                    guidController.text,
                                    nameController.text,
                                    surnameController.text,
                                    phoneController.text,
                                    addressController.text,
                                    emailController.text,
                                  ),
                                );
                            const Center(child: CircularProgressIndicator());
                          }
                        },
                        child: const Text('Update Profile'),
                      ),
                    ],
                  );
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
