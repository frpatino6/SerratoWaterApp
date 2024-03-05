import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serrato_water_app/bloc/auth/auth_bloc.dart';
import 'package:serrato_water_app/bloc/auth/auth_event.dart';
import 'package:serrato_water_app/bloc/auth/auth_state.dart';
import 'package:serrato_water_app/bloc/usert_type/user_type_bloc.dart';
import 'package:serrato_water_app/bloc/usert_type/user_type_event.dart';
import 'package:serrato_water_app/bloc/usert_type/user_type_state.dart';
import 'package:serrato_water_app/models/user_type_data.dart';
import 'package:serrato_water_app/screens/auth_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController =
      TextEditingController(text: "");
  final TextEditingController _lastNameController =
      TextEditingController(text: "");
  final TextEditingController _emailController =
      TextEditingController(text: "");
  final TextEditingController _addressController =
      TextEditingController(text: "");
  final TextEditingController _phoneController =
      TextEditingController(text: "");
  final TextEditingController _companyNameController =
      TextEditingController(text: "");

  final TextEditingController _socialSecurityController =
      TextEditingController();

  String? _userType;
  String? _parentUserType;
  String? _selectedUser;

  @override
  void initState() {
    super.initState();
    context.read<UserTypeBloc>().add(LoadUserType('frpatino6@gmail.com'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const AuthScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              userTypeDropdown(),
              const SizedBox(height: 10),
              parentUserDropdown(),
              const SizedBox(height: 10),
              ..._buildUserSpecificFields(),
              submitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget userTypeDropdown() {
    return BlocBuilder<UserTypeBloc, UserTypeState>(
      builder: (context, state) {
        List<DropdownMenuItem<String>> dropdownItems = [];
        Map<String, String> valueMap = {};

        if (state is UserTypeLoaded) {
          dropdownItems = state.userTypes
              .map<DropdownMenuItem<String>>((UserTypeData userTypeData) {
            valueMap[userTypeData.type] = userTypeData.userTypeParent;
            return DropdownMenuItem<String>(
              value: userTypeData.type,
              child: Text(userTypeData.type),
            );
          }).toList();
        }

        return DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'User Type'),
          value:
              _userType, // Usa la variable de estado _userType como el valor actual
          items: dropdownItems,
          onChanged: (String? newValue) {
            setState(() {
              _userType = newValue ?? '';
              _parentUserType = newValue != null ? valueMap[newValue] : null;
            });
            if (_userType != null) {
              context.read<AuthBloc>().add(LoadUserListEvent(_parentUserType!));
            }
          },
          validator: (String? value) => value == null || value.isEmpty
              ? 'Please select a user type'
              : null,
        );
      },
    );
  }

  Widget parentUserDropdown() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        List<String> userList = [];
        if (state is UserListLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is UserListLoadedState) {
          userList = state.userList;
        }

        return DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Parent user'),
          items: userList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) =>
              setState(() => _selectedUser = newValue),
          validator: (String? value) => value == null || value.isEmpty
              ? 'Please select a parent user'
              : null,
        );
      },
    );
  }

  Widget submitButton() {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        }
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("User added successfully")));
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        if (state is AuthRegisteringState) {
          return const Center(child: CircularProgressIndicator());
        }

        return ElevatedButton(
          onPressed: (state is! AuthLoading && state is! AuthRegisteringState)
              ? () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Validación específica para Dealers y companyName
                    if (_userType == 'Dealer' &&
                        _companyNameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Please enter a company name")),
                      );
                      return; // Detiene la ejecución si falla esta validación
                    }

                    // A partir de aquí, el código es el mismo que ya tienes,
                    // ya que las otras validaciones son manejadas por el _formKey.currentState?.validate()
                    if (_userType == 'Dealer') {
                      context.read<AuthBloc>().add(
                            RegisterEvent(
                              email: _emailController.text,
                              password: _emailController.text,
                              userType: _userType!,
                              selectedUserType: _selectedUser,
                              address: _addressController.text,
                              phone: _phoneController.text,
                              socialSecurityNumber:
                                  _socialSecurityController.text,
                              parentUser: _selectedUser!,
                              companyName: _companyNameController.text,
                              status: 0,
                            ),
                          );
                    } else {
                      context.read<AuthBloc>().add(
                            RegisterEvent(
                              email: _emailController.text,
                              password: _socialSecurityController.text,
                              firstName: _firstNameController.text,
                              lastName: _lastNameController.text,
                              userType: _userType!,
                              selectedUserType: _selectedUser,
                              address: _addressController.text,
                              phone: _phoneController.text,
                              socialSecurityNumber:
                                  _socialSecurityController.text,
                              parentUser: _selectedUser!,
                              status: 0,
                            ),
                          );
                    }
                  }
                }
              : null,
          child: const Text('Register'),
        );
      },
    );
  }

  TextFormField buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
    bool acceptOnlyNumbers =
        false, // Nuevo parámetro para controlar la validación de números
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: acceptOnlyNumbers
          ? TextInputType.number
          : TextInputType.text, // Cambia el tipo de teclado si es necesario
      decoration: InputDecoration(labelText: labelText),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $labelText';
        }
        if (labelText == 'Email' &&
            !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        if (labelText == 'Password' && value.length < 6) {
          return 'Please enter a password with at least 6 characters';
        }
        if (acceptOnlyNumbers && !RegExp(r'^\d*$').hasMatch(value)) {
          // Validación para aceptar solo números si es necesario
          return 'Please enter only numbers';
        }
        return null;
      },
    );
  }

  List<Widget> _buildUserSpecificFields() {
    if (_userType == 'Dealer') {
      // Si el tipo de usuario es 'Dealer', solicita 'Company Name'
      return [
        buildTextField(
            controller: _companyNameController, labelText: 'Company Name'),
        const SizedBox(height: 10),
        buildTextField(controller: _emailController, labelText: 'Email'),
      ];
    } else {
      return [
        buildTextField(
            controller: _firstNameController, labelText: 'First Name'),
        const SizedBox(height: 10),
        buildTextField(controller: _lastNameController, labelText: 'Last Name'),
        const SizedBox(height: 10),
        const SizedBox(height: 10),
        buildTextField(controller: _addressController, labelText: 'Address'),
        buildTextField(
            controller: _phoneController,
            labelText: 'Phone',
            acceptOnlyNumbers: true),
        const SizedBox(height: 10),
        buildTextField(controller: _emailController, labelText: 'Email'),
        const SizedBox(height: 10),
        buildTextField(
            acceptOnlyNumbers: true,
            controller: _socialSecurityController,
            labelText: 'Social Security Number/Itin'),
        const SizedBox(height: 20),
      ];
    }
  }
}
