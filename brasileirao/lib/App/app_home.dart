import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// import 'package:flutter/foundation.dart';
// import 'dart:math' as math;
// import 'pages/divisoes/serie_A.dart';
// import 'pages/divisoes/serie_B.dart';
// import 'pages/divisoes/serie_C.dart';
// import 'pages/noticias.dart';
// import 'pages/perfil.dart';

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

enum TableStatus { idle, loading, ready, error }

// Nosso humilde "controller"
class DataService {
  final ValueNotifier<Map<String, dynamic>> tableStateNotifier =
      ValueNotifier({'status': TableStatus.idle, 'dataObjects': []});
  final ValueNotifier<List<String>> columnsNamesNotifier = ValueNotifier([]);
  final ValueNotifier<List<String>> propetyNamesNotifier = ValueNotifier([]);

  void chamarApi(index) {
    final requisicoes = [partidas];
    tableStateNotifier.value = {
      'status': TableStatus.loading,
      'dataObjects': []
    };
    requisicoes[index]();
  }

// https://api.api-futebol.com.br/v1/campeonatos/10/rodadas/8
  Future<void> partidas() async {
    var recPartidas = Uri(
        scheme: 'https',
        host: 'api.api-futebol.com.br',
        path: 'v1/campeonatos/10/rodadas/8');

    try {
      var jsonString = await http.read(recPartidas, headers: {'Authorization': 'Bearer live_b8af81619c2465683b1395abe5568b'});
      var partidasJson = jsonDecode(jsonString)["partidas"];
      // print(partidasJson);
      tableStateNotifier.value = {
        'status': TableStatus.ready,
        'dataObjects': partidasJson
      };
      propetyNamesNotifier.value = ["placar"];
      columnsNamesNotifier.value = ["Placar"];
    } catch (e) {
      // print(e);
      tableStateNotifier.value = {
        'status': TableStatus.error,
        'dataObjects': []
      };
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("data"),
        ),
        body: const MyBody(),
        bottomNavigationBar:
            MyBottomNav(itemSelectedCallback: dataService.chamarApi),
      ),
    );
  }
}

var dataService = DataService();

class MyBody extends StatelessWidget {
  const MyBody({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ValueListenableBuilder(
        valueListenable: dataService.tableStateNotifier,
        builder: (_, value, __) {
          switch (value['status']) {
            case TableStatus.idle:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                        "https://i0.wp.com/quintanagastronomia.com.br/wp-content/uploads/2018/06/ecogastronomia-logo-branco.png?fit=500%2C200&ssl=1"),
                    const SizedBox(height: 10),
                    const Text(
                        "Escolha uma opção do cardapio nos botoes abaixo")
                  ],
                ),
              );
            case TableStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case TableStatus.ready:
              return DataTableWidget(jsonObjects: value['dataObjects']);
            case TableStatus.error:
              return const Center(
                  child: Text("Aconteceu um imprevisto, chame o DevOps"));
          }
          return const Text("...");
        });
  }
}

class DataTableWidget extends StatelessWidget {
  final List jsonObjects;

  const DataTableWidget({super.key, this.jsonObjects = const []});

  @override
  Widget build(BuildContext context) {
    final columnNames = dataService.columnsNamesNotifier.value;
    final propertyNames = dataService.propetyNamesNotifier.value;
    return DataTable(
        columns: columnNames
            .map((name) => DataColumn(
                label: Expanded(
                    child: Text(name,
                        style: const TextStyle(fontStyle: FontStyle.italic)))))
            .toList(),
        rows: jsonObjects
            .map((obj) => DataRow(
                cells: propertyNames
                    .map((propName) => DataCell(Text(obj[propName])))
                    .toList()))
            .toList());
  }
}

class MyBottomNav extends HookWidget {
  final _itemSelectedCallback;

  MyBottomNav({itemSelectedCallback})
      : _itemSelectedCallback = itemSelectedCallback ?? (int);

  @override
  Widget build(BuildContext context) {
    var state = useState(1);

    return BottomNavigationBar(
        onTap: (index) {
          state.value = index;

          _itemSelectedCallback(index);
        },
        currentIndex: state.value,
        items: const [
          BottomNavigationBarItem(
            label: "Cafés",
            icon: Icon(Icons.coffee_outlined),
          ),
          BottomNavigationBarItem(
              label: "Cervejas", icon: Icon(Icons.local_drink_outlined)),
          BottomNavigationBarItem(
              label: "Nações", icon: Icon(Icons.flag_outlined))
        ]);
  }
}
