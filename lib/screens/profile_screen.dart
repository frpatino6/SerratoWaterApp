import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serrato_water_app/api/fireBaseApi.dart';
import 'package:serrato_water_app/bloc/auth/auth_bloc.dart';
import 'package:serrato_water_app/bloc/auth/auth_event.dart';
import 'package:serrato_water_app/bloc/profile/profile_bloc.dart';
import 'package:serrato_water_app/bloc/profile/profile_event.dart';
import 'package:serrato_water_app/bloc/profile/profile_state.dart';
import 'package:serrato_water_app/screens/auth_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
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

  final String userName;
  final String userType;
  ProfileScreen({Key? key, required this.userName, required this.userType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(FirebaseAPI()),
      child: Builder(
        builder: (context) {
          context.read<ProfileBloc>().add(LoadUserProfile(userName));

          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
              actions: <Widget>[
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
                  if (userType == 'Dealer') {
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
                                        companyNameController.text,
                                        companyAddressController.text,
                                        companyPhoneController.text,
                                        einController.text,
                                        1,
                                        userType,
                                        firstKeyController.text),
                                  );
                              const Center(child: CircularProgressIndicator());
                            }
                          },
                          child: const Text('Update Profile'),
                        ),
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
                                        "",
                                        "",
                                        "",
                                        "",
                                        1,
                                        userType,
                                        firstKeyController.text),
                                  );
                              const Center(child: CircularProgressIndicator());
                            }
                          },
                          child: const Text('Update Profile'),
                        ),
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
