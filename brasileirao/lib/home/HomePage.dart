import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../components/Drawer.dart';
import '../utils/Controller.dart';
import 'package:brasileirao/sections/DataTable.dart';
import 'package:brasileirao/assets/Fontes.dart';

var dataService = DataService();

class MyApp extends StatelessWidget {
  final VoidCallback logoutCallback;
  const MyApp({Key? key, required this.logoutCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              "Brasileirão Max",
              style: Fontes().FontHeader(),
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
  const MyBody({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ValueListenableBuilder(
        valueListenable: dataService.tableStateNotifier,
        builder: (_, value, __) {
          switch (value['status']) {
            case TableStatus.idle:
              return const Center(
                child: Text("Clique em algo para continuar"),
              );
            case TableStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case TableStatus.readyMatches:
              return DataTableWidget(
                jsonObjects: value['dataObjects'],
                columnNames: dataService.columnsNamesNotifier.value,
                propertyNames: dataService.propetyNamesNotifier.value,
              );
            case TableStatus.error:
              return const Center(
                  child: Text("Aconteceu um imprevisto, chame o DevOps"));
          }
          return const Text("...");
        });
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
            label: "Classificação",
            icon: Icon(Icons.coffee_outlined),
          ),
          BottomNavigationBarItem(
              label: "Cervejas", icon: Icon(Icons.local_drink_outlined)),
          BottomNavigationBarItem(
              label: "Nações", icon: Icon(Icons.flag_outlined))
        ]);
  }
}
