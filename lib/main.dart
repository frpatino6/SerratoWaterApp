import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serrato_water_app/api/credit_application_api.dart';
import 'package:serrato_water_app/bloc/auth/auth_bloc.dart';
import 'package:serrato_water_app/api/fireBaseApi.dart';
import 'package:serrato_water_app/bloc/credit_application/credit_application_bloc.dart';
import 'package:serrato_water_app/screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(api: FirebaseAPI()),
        ),
        BlocProvider(
          create: (context) =>
              CreditApplicationBloc(api: CreditApplicationApi()),
        ),
        // Añade otros BlocProviders aquí si los tienes
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Firebase Auth with BLoC',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AuthScreen(),
      ),
    );
  }
}
