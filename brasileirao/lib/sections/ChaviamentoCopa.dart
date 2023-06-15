import 'package:flutter/material.dart';

class PartidasCopa extends StatelessWidget {
  final List jsonObjects;

  PartidasCopa({super.key, required this.jsonObjects});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: jsonObjects.length,
        
        // shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              // Expanded(
              // child:
              ListTile(
                onTap: () => "aaaa",
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
              )),
              ListTile(
                onTap: () => "aaaa",
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
              )),
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
