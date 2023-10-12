import 'package:flutter/material.dart';
import 'bloc/login/login_bloc.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/cosmetic_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'services/shared_service.dart';
import 'services/auth_service.dart';

Widget _defaultHome = const LoginPage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get result of the login function.
  bool _result = await SharedService.isLoggedIn();
  if (_result) {
    _defaultHome = const HomePage();
  }

  setupAuthClient();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: MaterialApp(
        title: 'BeautyMinder',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        routes: {
          '/': (context) => _defaultHome,
          '/home': (context) => const HomePage(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/cosmetic': (context) => CosmeticPage(),
        },
      ),
    );
  }
}