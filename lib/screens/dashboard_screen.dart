import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serrato_water_app/bloc/auth/auth_bloc.dart';
import 'package:serrato_water_app/bloc/auth/auth_event.dart';
import 'package:serrato_water_app/screens/auth_screen.dart';
import 'package:serrato_water_app/screens/data_capture_screen.dart';
import 'package:serrato_water_app/screens/mis_transacciones_screen.dart';
import 'package:serrato_water_app/screens/profile_screen.dart';
import 'package:serrato_water_app/screens/register_screen.dart';
import 'package:serrato_water_app/screens/single_data_capture_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatelessWidget {
  final String userName;
  const DashboardScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout_sharp),
            onPressed: () async {
              BlocProvider.of<AuthBloc>(context).add(LogoutEvent());

              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false);
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const AuthScreen()));
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex:
                1, // El flex determina la proporción de espacio que cada botón debe ocupar
            child: InkWell(
              onTap: () => _showFinancingQuestion(context),
              child: const Card(
                margin: EdgeInsets.all(8.0),
                color: Colors.blueAccent,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.add, size: 50.0),
                      Text('Add New Client', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                // Navigate to Transactions screen
                _onViewTransactions(context);
              },
              child: const Card(
                margin: EdgeInsets.all(8.0),
                color: Colors.greenAccent,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.list, size: 50.0),
                      Text('View Transactions', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                _onViewProfile(context);
              },
              child: const Card(
                margin: EdgeInsets.all(8.0),
                color: Colors.orangeAccent,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.account_circle, size: 50.0),
                      Text('Profile', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                _onViewUserRegister(context);
              },
              child: const Card(
                margin: EdgeInsets.all(8.0),
                color: Colors
                    .lightBlueAccent, // Cambiado a un color que sugiera una acción de 'crear' o 'añadir'
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.person_add,
                          size: 50.0), // Icono para 'añadir persona'
                      Text('Create User', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onViewTransactions(BuildContext context) {
    // Aquí va el código para navegar a la pantalla de transacciones
    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const MisTransaccionesScreen()));
  }

  void _onViewProfile(BuildContext context) {
    // Aquí va el código para navegar a la pantalla de transacciones
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ProfileScreen(
              userName: userName,
            )));
  }

  void _onViewUserRegister(BuildContext context) {
    // Aquí va el código para navegar a la pantalla de transacciones
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const RegisterScreen()));
  }

  void _showFinancingQuestion(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Does the customer need financing?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green, // foreground (text) color
              ),
              child: const Text('Yes'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const DataCaptureScreen()));
              },
            ),
            TextButton(
              child:
                  const Text('No', style: TextStyle(color: Colors.redAccent)),
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const SingleDataCaptureScreen()));
              },
            ),
          ],
        );
      },
    );
  }
}
