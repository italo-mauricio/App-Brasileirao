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
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          title: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Posição: ${jsonObjects[index]['posicao']}'),
                    Text('Pontos: ${jsonObjects[index]['pontos']}'),
                    Text('Nome Popular: ${jsonObjects[index]['nome_popular']}'),
                    Text('Sigla: ${jsonObjects[index]['sigla']}'),
                  ],
                ),
              ),
              SizedBox(
                width: 50,
                height: 50,
                child: Image.network(jsonObjects[index]['escudo']),
              ),
            ],
          ),
        );
      },
    );
  }
}
