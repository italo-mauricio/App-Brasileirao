import 'package:brasileirao/controllers/BrasileiraoController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Description extends HookWidget {
  final int id;
  final value;
  Description({super.key, required this.id, required this.value});

  @override
  Widget build(BuildContext context) {

    if (dataService.selectedPartidaId != id) {
      return Text("");
    }

    switch (value['status']) {
      case DescripitonStatus.idle:
        return Text("data");
      case DescripitonStatus.loading:
        return const Center(
            child: CircularProgressIndicator(
          color: Color.fromARGB(249, 18, 245, 10),
        ));
      case DescripitonStatus.ready:
        final textsGolsM = value['data']["gols_m"]
            .map<Widget>((gol) => Text(
                "Autor do Gol: ${gol["atleta"]["nome_popular"]?? "..."}\nTempo: ${gol["minuto"]?? "..."}\nPeriodo: ${gol["periodo"]?? "..."}"))
            .toList()?? "...";

        final textsGolsV = value['data']["gols_v"]
            .map<Widget>((gol) => Text(
                "Autor do Gol: ${gol["atleta"]["nome_popular"]}\nTempo: ${gol["minuto"]?? "..."}\nPeriodo: ${gol["periodo"]?? "..."}"))
            .toList()?? "...";
        return Column(
          children: [
            Text("${value['data']["status"]}"),
            Text("Local: ${value['data']["local"]}"),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(children: textsGolsM?? const Text("")),
              Column(children: textsGolsV?? const Text(""))
            ]),
          ],
        );
    }
    return const Text("Erro");

  }
}
