import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart'; // Importa firebase_core
import 'package:serrato_water_app/api/credit_application_api.dart';
import 'package:serrato_water_app/api/user_type_api.dart';
import 'package:serrato_water_app/bloc/auth/auth_bloc.dart';
import 'package:serrato_water_app/api/fireBaseApi.dart';
import 'package:serrato_water_app/bloc/credit_application/credit_application_bloc.dart';
import 'package:serrato_water_app/bloc/sales_list/sales_bloc.dart';
import 'package:serrato_water_app/bloc/usert_type/user_type_bloc.dart';
import 'package:serrato_water_app/providers/user_provider.dart';
import 'package:serrato_water_app/screens/auth_screen.dart';

// Modifica el método main para inicializar Firebase
void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Asegúrate de que está llamado antes de inicializar Firebase
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyAlknAEEg2EroaQvYh9dPNM3Kda80CITvU',
          appId: 'SerratoWaterApp',
          messagingSenderId: '169882497159',
          storageBucket: 'serratowaterapp-79627.appspot.com',
          projectId: 'serratowaterapp-79627'));

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        BlocProvider(
          create: (context) => SalesBloc(api: CreditApplicationApi()),
        ),
        BlocProvider(
          create: (context) => UserTypeBloc(api: UsertTypeApi()),
        ),
        // Añade otros BlocProviders aquí si los tienes
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Serrato Water App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AuthScreen(),
      ),
    );
  }
}
