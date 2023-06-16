import 'package:flutter/material.dart';
import 'package:brasileirao/controllers/BrasileiraoController.dart';

class DrawerApp extends StatelessWidget {
  final VoidCallback logoutCallback;

  const DrawerApp({required this.logoutCallback, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color.fromRGBO(35, 131, 51, 1.0);

    return Drawer(
      child: Column(
        children: [
          Column(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.asset('lib/assets/logo.png'),
                ),
                accountName: const Text('Usuário'),
                accountEmail: const Text('usuariobrasileirao@gmail.com'),
                decoration: const BoxDecoration(
                  color: primaryColor,
                ),
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Início'),
            subtitle: const Text('Tela de Início'),
            onTap: () {
              dataService.tableStateNotifier.value = {
                'status': TableStatus.idle,
              };
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            subtitle: const Text('Finalizar sessão'),
            onTap: logoutCallback, // Chama o callback de logout
          ),
        ],
      ),
    );
  }
}