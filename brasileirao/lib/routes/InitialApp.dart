import 'package:flutter/material.dart';
import '../login/LoginPage.dart';
import '../home/HomePage.dart';



class AppWidget extends StatelessWidget {
  const AppWidget({super.key});
  @override
  Widget build(BuildContext context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
          initialRoute: '/home',
          routes: {
     //       '/': (context) => const LoginPage(key: null,),
            '/home': (context) => MyApp(),
          },
        );
  }
}