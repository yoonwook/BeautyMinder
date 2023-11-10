
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/register/register_bloc.dart';
import 'bloc/login/login_bloc.dart';
import 'bloc/cosmetic/cosmetic_bloc.dart';
import 'bloc/cosmetic_expiry/cosmetic_expiry_bloc.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/cosmetic_page.dart';
import 'pages/expiry_page.dart';
import 'pages/review_page.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginBloc()),
        BlocProvider(create: (context) => RegisterBloc()),
        BlocProvider(create: (context) => CosmeticBloc()),
        BlocProvider(create: (context) => CosmeticExpiryBloc()),
      ],
      child: MaterialApp(
        title: 'BeautyMinder',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        routes: {
          '/': (context) => _defaultHome,
          '/home': (context) => const HomePage(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => RegisterPage(),
          '/cosmetic': (context) => CosmeticPage(),
          '/cosmetic-expiry': (context) => CosmeticExpiryPage(),
          '/review': (context) => CosmeticReviewPage(),
        },
      ),
    );
  }
}
