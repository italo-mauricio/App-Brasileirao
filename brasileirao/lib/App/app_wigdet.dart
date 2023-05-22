import 'package:flutter/material.dart';
import 'login_page.dart';
import 'app_home.dart';



class AppWidget extends StatelessWidget {
  const AppWidget({super.key});
  @override
  Widget build(BuildContext context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const LoginPage(key: null,),
            '/home': (context) => MyApp(),
          },
        );
  }
}