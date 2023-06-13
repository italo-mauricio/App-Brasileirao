import 'package:flutter/material.dart';

class TableWidget extends StatefulWidget {
  final List<Map<String, dynamic>> jsonObjects;

  const TableWidget({Key? key, required this.jsonObjects}) : super(key: key);

  @override
  _TableWidgetState createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  bool orderByAlphabetical = false;
  List<Map<String, dynamic>> sortedJsonObjects = [];

  @override
  void initState() {
    super.initState();
    sortedJsonObjects = List.from(widget.jsonObjects);
  }

  @override
  Widget build(BuildContext context) {
    // Função para ordenar os objetos por ordem alfabética
    void sortAlphabetical() {
      sortedJsonObjects.sort((a, b) =>
          a['nome_popular'].compareTo(b['nome_popular']));
    }

    if (orderByAlphabetical) {
      sortAlphabetical(); // Ordena os objetos alfabeticamente
    }

    // Função para reverter a ordem para a padrão
    void resetOrder() {
      setState(() {
        orderByAlphabetical = false;
        sortedJsonObjects = List.from(widget.jsonObjects);
      });
    }

    return Column(
      children: [
        Text(
          'Tabela Brasileirão Série A',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            PopupMenuButton<String>(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'default',
                  child: Text('Ordem Padrão'),
                ),
                const PopupMenuItem(
                  value: 'alphabetical',
                  child: Text('Ordem Alfabética'),
                ),
              ],
              onSelected: (value) {
                if (value == 'alphabetical') {
                  setState(() {
                    orderByAlphabetical = true;
                    sortAlphabetical();
                  });
                } else if (value == 'default') {
                  resetOrder();
                }
              },
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: sortedJsonObjects.length,
            itemBuilder: (context, index) {
              return ListTile(
                trailing: Image.network(sortedJsonObjects[index]['escudo']),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Posição: ${sortedJsonObjects[index]['posicao']}',
                    ),
                    Text(
                      'Pontos: ${sortedJsonObjects[index]['pontos']}',
                    ),
                    Text(
                      'Nome Popular: ${sortedJsonObjects[index]['nome_popular']}',
                    ),
                    Text(
                      'Sigla: ${sortedJsonObjects[index]['sigla']}',
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
