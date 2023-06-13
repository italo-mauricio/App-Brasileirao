import 'package:brasileirao/sections/Table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../components/Drawer.dart';
import '../controllers/BrasileiraoController.dart';
import 'package:brasileirao/sections/Matches.dart';
import 'package:brasileirao/assets/Fontes.dart';


class MyApp extends StatelessWidget {
  final VoidCallback logoutCallback;

  const MyApp({Key? key, required this.logoutCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize:
              const Size.fromHeight(56), // Defina a altura desejada da AppBar
          child: AppBar(
            backgroundColor: const Color.fromRGBO(35, 131, 51, 1.0),
            title: Container(
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Brasileirão Max",
                        style:
                            Fontes().FontHeader().copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Image.asset(
                    'lib/assets/logo_vintage.png',
                    width: 50,
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: const MyBody(),
        drawer: DrawerApp(logoutCallback: logoutCallback),
        bottomNavigationBar:
            MyBottomNav(itemSelectedCallback: dataService.chamarApi),
      ),
    );
  }
}

class MyBody extends StatelessWidget {
  const MyBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map<String, dynamic>>(
      valueListenable: dataService.tableStateNotifier,
      builder: (_, value, __) {
        switch (value['status']) {
          case TableStatus.idle:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Clique em algo para continuar"),
                  const SizedBox(height: 16),
                  Image.asset(
                    'lib/assets/logo_vintage.png',
                    width: 200,
                    height: 200,
                  ),
                ],
              ),
            );
          case TableStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case TableStatus.readyMatches:
            return Column(children: [
              SizedBox(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        iconSize: 30,
                        icon: const Icon(Icons.chevron_left_sharp),
                        onPressed: (() {
                          dataService.partidasR(dataService.rodada--);
                        })),
                    Text("Rodada: ${dataService.rodada}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                      iconSize: 30,
                      icon: const Icon(Icons.chevron_right_sharp),
                      onPressed: (() {
                        dataService.partidasR(dataService.rodada++);
                      }),
                    ),
                  ],
                ),
              ),
              Expanded(child: MatchesWidget(jsonObjects: value['dataObjects']))
            ]);
          case TableStatus.readyTable:
            return TableWidget(jsonObjects: value['dataObjects']);
          case TableStatus.readyPhase:
            return Text("$value['dataObjects']");
          case TableStatus.error:
            return const Center(
                child: Text("Aconteceu um imprevisto, chame o DevOps"));
        }
        return const Text("...");
      },
    );
  }
}

class MyBottomNav extends HookWidget {
  final _itemSelectedCallback;

  MyBottomNav({required Function(int) itemSelectedCallback})
      : _itemSelectedCallback = itemSelectedCallback;

  @override
  Widget build(BuildContext context) {
    var state = useState(0); // Defina o índice inicial do botão selecionado

    return BottomNavigationBar(
      backgroundColor: const Color.fromRGBO(35, 131, 51, 1.0),
      selectedItemColor: const Color.fromRGBO(252, 193, 79, 1.0),
      unselectedItemColor: const Color.fromARGB(248, 248, 248, 248),
      selectedFontSize: 12.0,
      showSelectedLabels: true, // Exibir rótulos dos botões selecionados
      showUnselectedLabels:
          false, // Ocultar rótulos dos botões não selecionados
      type: BottomNavigationBarType
          .fixed, // Exibir todos os botões mesmo quando adicionados mais um
      onTap: (index) {
        state.value = index;
        _itemSelectedCallback(index);
      },

      currentIndex: state.value,
      items: const [
        BottomNavigationBarItem(
          label: "Classificação",
          icon: Icon(Icons.bar_chart_outlined),
        ),
        BottomNavigationBarItem(
          label: "Partidas",
          icon: Icon(Icons.sports_soccer),
        ),
        BottomNavigationBarItem(
          label: "Chaveamento Copa do Brasil",
          icon: Icon(Icons.star),
        ),
        BottomNavigationBarItem(
            label: "Partidas Copa do Brasil", icon: Icon(Icons.abc))
      ],
    );
  }
}
