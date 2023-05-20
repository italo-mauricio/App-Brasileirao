import 'package:flutter/foundation.dart';


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'pages/divisoes/serie_A.dart';
import 'pages/divisoes/serie_B.dart';
import 'pages/divisoes/serie_C.dart';
import 'pages/noticias.dart';
import 'pages/perfil.dart';


//void Atividade1() {
 // runApp(MyApp());
//}

// fontes para usar no resto do código
TextStyle _FontHeader = GoogleFonts.openSans(
  fontSize: 30,
  fontWeight: FontWeight.bold,
  fontStyle: FontStyle.normal,
  color: Colors.black,
);

TextStyle _FontNormalText = GoogleFonts.openSans(
  fontSize: 20,
  fontWeight: FontWeight.normal,
  fontStyle: FontStyle.normal,
  color: Colors.black,
);

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _Index = 0;
  final List<Widget> _pages = [
    Center(child: noticias()),
    Center(child: tabela_seria_A()),
    Center(child: tabela_seria_B()),
    Center(child: tabela_seria_C()),
    Center(child: meu_perfil()),
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
      theme: ThemeData(colorScheme: const ColorScheme.light()),
      home: Scaffold(
           drawer: Drawer(
        child: Column(children: [
          Column(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.network('https://www.google.com/url?sa=i&url=https%3A%2F%2Fpt.vecteezy.com%2Farte-vetorial%2F2387693-icone-do-perfil-do-usuario&psig=AOvVaw0E78JoqejATrrYR5C0HWPr&ust=1684632317186000&source=images&cd=vfe&ved=0CBEQjRxqFwoTCLjh-sregv8CFQAAAAAdAAAAABAD')),
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
          backgroundColor: Colors.blueAccent,
          title: Text("Barcelona Futebol Clube", style: _FontHeader),
          centerTitle: true,
        ),
        body: IndexedStack(
          index: _Index,
          children: _pages,
        ),
        bottomNavigationBar: Theme(
          data: ThemeData(canvasColor: Colors.redAccent),
          child: BottomNavigationBar(
            currentIndex: _Index,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.amber,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Inicial",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.grade),
                label: "Lionel Messi",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Camp Nou",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.emoji_events),
                label: "Títulos",
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