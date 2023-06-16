import 'package:brasileirao/controllers/BrasileiraoController.dart';
import 'package:flutter/material.dart';
import 'DescriptionsMatches.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';

class MatchesWidget extends StatelessWidget {
  final List jsonObjects;

  const MatchesWidget({Key? key, required this.jsonObjects}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return ListView.builder(
      itemCount: jsonObjects.length,
      itemBuilder: (BuildContext context, int index) {
        final partidaId = jsonObjects[index]["partida"];
        return ListTile(
          onTap: () {
            dataService.descricaoPartidas(partidaId);
          },
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Image.network(
                      jsonObjects[index]["time_mandante"],
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                    Text(jsonObjects[index]["sigla_mandante"]),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      jsonObjects[index]["placar"],
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                        "Data: ${jsonObjects[index]["data"]}\tHora: ${jsonObjects[index]["hora"]}"),
                  ],
                ),
                Column(
                  children: [
                    Image.network(
                      jsonObjects[index]["time_visitante"],
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                    Text(jsonObjects[index]["sigla_visitante"]),
                  ],
                ),
              ],
            ),
          ),
          subtitle: ValueListenableBuilder(
              valueListenable: dataService.descriptionNotifier,
              builder: (context, value, child) =>
                  Description(id: partidaId, value: value)),
        );
      },
    );
  }
}