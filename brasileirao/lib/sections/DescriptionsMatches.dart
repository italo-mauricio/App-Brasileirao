import 'package:brasileirao/controllers/BrasileiraoController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Description extends HookWidget {
  final int id;
  Description({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      dataService.descricaoPartidas(id);
    }, []);

    return ValueListenableBuilder(
        valueListenable: dataService.descriptionNotifier,
        builder: (context, value, child) {
          switch (value['status']) {
            case DescripitonStatus.loading:
              return const Center(
                  child: CircularProgressIndicator(
                color: Color.fromARGB(249, 18, 245, 10),
              ));
            case DescripitonStatus.ready:
              final textsGolsM = value['data']["gols_m"]
                  .map<Widget>((gol) => Text(
                      "Autor do Gol: ${gol["atleta"]["nome_popular"]}\nTempo: ${gol["minuto"]}\nPeriodo: ${gol["periodo"]}"))
                  .toList();

              final textsGolsV = value['data']["gols_v"]
                  .map<Widget>((gol) => Text(
                      "Autor do Gol: ${gol["atleta"]["nome_popular"]}\nTempo: ${gol["minuto"]}\nPeriodo: ${gol["periodo"]}"))
                  .toList();
              return Column(
                children: [
                  Text("${value['data']["status"]}"),
                  Text("Local: ${value['data']["local"]}"),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(children: textsGolsM),
                        Column(children: textsGolsV)
                      ]),
                ],
              );
          }
          return const Text("Erro");
        });
  }
}