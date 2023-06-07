import 'package:flutter/material.dart';

class TableWidget extends StatelessWidget {
  final List<Map<String, dynamic>> jsonObjects;
  const TableWidget({Key? key, required this.jsonObjects}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: jsonObjects.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Image.network(jsonObjects[index]['escudo']),
          title: Text('Posição: ${jsonObjects[index]['posicao']}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pontos: ${jsonObjects[index]['pontos']}'),
              Text('Nome Popular: ${jsonObjects[index]['nome_popular']}'),
              Text('Sigla: ${jsonObjects[index]['sigla']}'),
            ],
          ),
        );
      },
    );
  }
}
