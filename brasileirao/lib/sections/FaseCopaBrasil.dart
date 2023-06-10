import 'package:flutter/material.dart';

class FasesCopaWidget extends StatelessWidget {
  final List<Map<String, dynamic>> jsonObjects;

  const FasesCopaWidget({Key? key, this.jsonObjects = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: jsonObjects.length,
      itemBuilder: (BuildContext context, int index) {
        var object = jsonObjects[index];

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(object['edicao_id'].toString()),
                    Text(object['nome_popular']),
                    Text(object['nome']),
                    Text(object['temporada']),
                    Text(object['slug']),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
