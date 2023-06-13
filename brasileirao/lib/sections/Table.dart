import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tabela Brasileirão',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tabela Brasileirão'),
        ),
        body: const TableWidget(
          jsonObjects: [
            {
              'posicao': '1',
              'pontos': '78',
              'nome_popular': 'Time 1',
              'sigla': 'T1',
              'escudo': 'https://example.com/escudo1.png',
            },
            {
              'posicao': '2',
              'pontos': '72',
              'nome_popular': 'Time 2',
              'sigla': 'T2',
              'escudo': 'https://example.com/escudo2.png',
            },
            // Adicione mais objetos de time conforme necessário
          ],
        ),
      ),
    );
  }
}

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
    // Function to sort objects in alphabetical order
    void sortAlphabetical() {
      sortedJsonObjects.sort((a, b) =>
          a['nome_popular'].compareTo(b['nome_popular']));
    }

    if (orderByAlphabetical) {
      sortAlphabetical(); // Sort objects alphabetically
    }

    // Function to reset the order to the default
    void resetOrder() {
      setState(() {
        orderByAlphabetical = false;
        sortedJsonObjects = List.from(widget.jsonObjects);
      });
    }

    return Center(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color.fromRGBO(35, 131, 51, 1.0),
              borderRadius: BorderRadius.circular(7),
            ),
            child: const Text(
              'Tabela Brasileirão Série A',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.sort),
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
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: sortedJsonObjects.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TeamDetailsScreen(
                          teamData: sortedJsonObjects[index],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: SizedBox(
                        width: 48,
                        height: 48,
                        child: Image.network(
                          sortedJsonObjects[index]['escudo'],
                          fit: BoxFit.contain,
                        ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Posição: ${sortedJsonObjects[index]['posicao']}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Pontos: ${sortedJsonObjects[index]['pontos']}',
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Nome Popular: ${sortedJsonObjects[index]['nome_popular']}',
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Sigla: ${sortedJsonObjects[index]['sigla']}',
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TeamDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> teamData;

  TeamDetailsScreen({Key? key, required this.teamData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Time'),
        backgroundColor: const Color.fromRGBO(35, 131, 51, 1.0),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                teamData['escudo'],
                fit: BoxFit.contain,
                height: 200,
              ),
              const SizedBox(height: 10),
              Text(
                'Nome Popular: ${teamData['nome_popular']}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Posição: ${teamData['posicao']}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Pontos: ${teamData['pontos']}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Sigla: ${teamData['sigla']}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
