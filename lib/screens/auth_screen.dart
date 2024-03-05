import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:serrato_water_app/bloc/auth/auth_bloc.dart';
import 'package:serrato_water_app/bloc/auth/auth_event.dart';
import 'package:serrato_water_app/bloc/auth/auth_state.dart';
import 'package:serrato_water_app/providers/user_provider.dart';
import 'package:serrato_water_app/screens/dashboard_screen.dart';
import 'package:serrato_water_app/screens/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();

    checkLoginStatus(context);

    // _emailController.text = "frpatino6@gmail.com";
    // _passwordController.text = "123456";
    _emailController.text = "contoso@contoso.com";
    _passwordController.text = "contoso@contoso.com";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          } else if (state is AuthSuccess) {
            Provider.of<UserProvider>(context, listen: false)
                .setUsername(_emailController.text);

            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isLoggedIn', true);
            await prefs.setString('username', _emailController.text);
            await prefs.setString('password', _passwordController.text);
            await prefs.setString(
                'userType', state.userProfile!["user"]['userType']);
            await prefs.setInt('status', state.userProfile!["user"]['status']);

            // Verifica el valor de 'status'
            int status = state.userProfile!["user"]['status'];

            if (status == 0) {
              // Si 'status' es igual a '0', navega a ProfileScreen
              if (context.mounted) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (_) => ProfileScreen(
                          userName: _emailController.text,
                          userType: state.userProfile!["user"]['userType'],
                        )));
              }
            } else {
              // De lo contrario, continúa a DashboardScreen
              if (context.mounted) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (_) => DashboardScreen(
                          userName: _emailController.text,
                          userType: state.userProfile!["user"]['userType'],
                        )));
              }
            }
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(30.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      "assets/images/logo.png",
                      height: 180,
                      width: 280,
                    ),
                    const SizedBox(height: 50),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (state is AuthLoading) ...[
                      const CircularProgressIndicator(),
                      const SizedBox(height: 20),
                    ],
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(LoginEvent(
                            _emailController.text, _passwordController.text));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Future<bool> isUserLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
}

Future<String> getUserName() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('username') ?? '';
}

Future<String> getUserType() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('userType') ?? '';
}

Future<int> getUserStatus() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('status') ?? 0;
}

void checkLoginStatus(BuildContext context) async {
  bool isLoggedIn = await isUserLoggedIn();
  if (isLoggedIn) {
    String user = await getUserName();
    String userType = await getUserType();
    int status = await getUserStatus();

    if (status == 0) {
      if (context.mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => ProfileScreen(
                  userName: user,
                  userType: userType,
                )));
      }
    } else if (context.mounted) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => DashboardScreen(
                userName: user,
                userType: userType,
              )));
    }
  }
}
