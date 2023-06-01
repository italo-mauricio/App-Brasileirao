import 'package:flutter/foundation.dart';


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'package:brasileirao/assets/Fontes.dart';


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _Index = 0;
  final List<Widget> _pages = [
  ];

  void _onItemTapped(int index) {
    setState(() {
      _Index = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, // desabilitando o "debug" no canto da tela
      theme: ThemeData(colorScheme: const ColorScheme.light(primary: Color.fromARGB(255, 4, 194, 178))),
      home: Scaffold(
           drawer: Drawer(
        child: Column(children: [
          Column(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.asset('assets/images/logo_usuario.jpg')),
                accountName: const Text('Usuário'), accountEmail: const Text('usuariobrasileirao@gmail.com')),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            subtitle: const Text('Tela de Inicio'),
            onTap: () {
              if (kDebugMode) {
                print('home');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            subtitle: const Text('Finalizar sessão'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          )
        ]),
      ),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 149, 250, 99),
          title: Text("Max Fut", style: Fontes().FontHeader()),
          centerTitle: true,
        ),
        body: IndexedStack(
          index: _Index,
          children: _pages,
        ),
        bottomNavigationBar: Theme(
          data: ThemeData(canvasColor:  const Color.fromARGB(255, 4, 194, 178)),
          child: BottomNavigationBar(
            currentIndex: _Index,
            selectedItemColor: const Color.fromARGB(255, 210, 254, 88),
            unselectedItemColor: const Color.fromARGB(255, 17, 253, 233),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Notícias",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.grade),
                label: "Série A",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Série B",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.emoji_events),
                label: "Série C",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_box),
                label: "Perfil",
              ),
            ],
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}