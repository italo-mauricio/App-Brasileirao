import 'package:brasileirao/controllers/BrasileiraoController.dart';
import 'package:flutter/material.dart';

import 'DescriptionsMatches.dart';

class FasesCopa extends StatelessWidget {
  final List jsonObjects;

  FasesCopa({Key? key, required this.jsonObjects}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: jsonObjects.length,
      itemBuilder: (BuildContext context, int index) {
        final idIda = jsonObjects[index]["idIda"];
        return Column(
          children: [
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Image.network(
                            jsonObjects[index]["escudo1"],
                            width: 50,
                            height: 50,
                            fit: BoxFit.contain,
                          ),
                          Text(jsonObjects[index]["sigla1"]),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.green,
                      width: 1.0,
                      height: 50.0,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Image.network(
                            jsonObjects[index]["escudo2"],
                            width: 50,
                            height: 50,
                            fit: BoxFit.contain,
                          ),
                          Text(jsonObjects[index]["sigla2"]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              subtitle: ValueListenableBuilder(
                valueListenable: dataService.descriptionNotifier,
                builder: (context, value, child) =>
                    Description(id: idIda, value: value),
              ),
            ),
            const Divider(
              height: 20,
              color: Colors.green,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
          ],
        );
      },
    );
  }
}