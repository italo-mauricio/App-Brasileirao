import 'package:flutter/material.dart';

class DrawerApp extends StatelessWidget {
  const DrawerApp({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Column(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.asset('assets/logo.png'),
                ),
                accountName: const Text('Usuário'),
                accountEmail: const Text('usuariobrasileirao@gmail.com'),
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Início'),
            subtitle: const Text('Tela de Início'),
            onTap: () {
              // Ação quando o item é selecionado
              Navigator.pop(context); // Fechar o drawer
              // Adicione o código que deseja executar ao selecionar o item
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            subtitle: const Text('Finalizar sessão'),
            onTap: () {
              // Ação quando o item é selecionado
              Navigator.of(context).pushReplacementNamed('/');
              // Adicione o código que deseja executar ao selecionar o item
            },
          ),
        ],
      ),
    );
  }
}
