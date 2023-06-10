import 'package:flutter/material.dart';

class MatchesWidget extends StatelessWidget {
  final List jsonObjects;
  final int rounds;

  MatchesWidget({Key? key, required this.jsonObjects, required this.rounds})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.chevron_left_sharp),
          Text("10"),
          Icon(Icons.chevron_right_sharp)
        ],
      ),
      Expanded(
          child: ListView.builder(
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
              }))
    ]);
  }
}
