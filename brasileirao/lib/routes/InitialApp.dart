import 'package:flutter/material.dart';
import '../login/LoginPage.dart';
import '../home/HomePage.dart';



class AppWidget extends StatelessWidget {
  const AppWidget({Key? key});

  void logoutCallback(BuildContext context) {
  Navigator.pushReplacementNamed(context, '/'); // Redireciona para a tela de login
}


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => MyApp(logoutCallback: () => logoutCallback(context)),

      },
    );
  }
}