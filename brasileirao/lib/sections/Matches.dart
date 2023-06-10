import 'package:flutter/material.dart';
import '../controllers/BrasileiraoController.dart';

class MatchesWidget extends StatelessWidget {
  late final List jsonObjects;

  MatchesWidget({super.key, required this.jsonObjects});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: jsonObjects.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(children: [
                    Image.network(
                      jsonObjects[index]["time_mandante"],
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                    Text(jsonObjects[index]["sigla_mandante"]),
                  ]),
                  Column(children: [
                    Text(
                      jsonObjects[index]["placar"],
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(jsonObjects[index]["data"] +
                        " " +
                        jsonObjects[index]["hora"])
                  ]),
                  Column(children: [
                    Image.network(
                      jsonObjects[index]["time_visitante"],
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                    Text(jsonObjects[index]["sigla_visitante"]),
                  ]),
                ],
              ),
            ),
          );
        });
  }
}
