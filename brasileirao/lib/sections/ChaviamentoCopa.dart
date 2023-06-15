import 'package:brasileirao/controllers/BrasileiraoController.dart';
import 'package:flutter/material.dart';

import 'DescriptionsMatches.dart';

class PartidasCopa extends StatelessWidget {
  final List jsonObjects;

  PartidasCopa({super.key, required this.jsonObjects});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: jsonObjects.length,
        itemBuilder: (BuildContext context, int index) {
          final idIda = jsonObjects[index]["idIda"];
          final idVolta = jsonObjects[index]["idVolta"];
          return Column(
            children: [
              ListTile(
                  onTap: () {
                    dataService.descricaoPartidas(idIda);
                  },
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Image.network(jsonObjects[index]["escudo1"],
                                width: 50, height: 50, fit: BoxFit.contain),
                            Text(jsonObjects[index]["sigla1"])
                          ],
                        ),
                        Column(
                          children: [
                            Text(jsonObjects[index]["placarIda"]),
                            Text("Data: ${jsonObjects[index]["dataIda"]}"),
                            Text("Hora:${jsonObjects[index]["horarioIda"]}")
                          ],
                        ),
                        Column(
                          children: [
                            Image.network(jsonObjects[index]["escudo2"],
                                width: 50, height: 50, fit: BoxFit.contain),
                            Text(jsonObjects[index]["sigla2"])
                          ],
                        )
                      ],
                    ),
                    // ),
                  ),
                  subtitle: ValueListenableBuilder(
              valueListenable: dataService.descriptionNotifier,
              builder: (context, value, child) =>
                  Description(id: idIda, value: value)),
                  ),
              ListTile(
                  onTap: () {
                    dataService.descricaoPartidas(idVolta);
                  },
                  title: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Image.network(jsonObjects[index]["escudo2"],
                                width: 50, height: 50, fit: BoxFit.contain),
                            Text(jsonObjects[index]["sigla2"])
                          ],
                        ),
                        Column(
                          children: [
                            Text(jsonObjects[index]["placarVolta"]),
                            Text("Data: ${jsonObjects[index]["dataVolta"]}"),
                            Text("Hora:${jsonObjects[index]["horarioVolta"]}")
                          ],
                        ),
                        Column(
                          children: [
                            Image.network(jsonObjects[index]["escudo1"],
                                width: 50, height: 50, fit: BoxFit.contain),
                            Text(jsonObjects[index]["sigla1"])
                          ],
                        )
                      ],
                    ),
                  ),
                  subtitle: ValueListenableBuilder(
              valueListenable: dataService.descriptionNotifier,
              builder: (context, value, child) =>
                  Description(id: idVolta, value: value)),
                  ),
              const Divider(
                height: 20,
                color: Colors.green,
                thickness: 1,
                indent: 20,
                endIndent: 20,
              )
            ],
          );
        });
  }
}
