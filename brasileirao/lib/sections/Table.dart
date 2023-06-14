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
      sortedJsonObjects
          .sort((a, b) => a['nome_popular'].compareTo(b['nome_popular']));
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
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

  const TeamDetailsScreen({Key? key, required this.teamData}) : super(key: key);

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Detalhes do Time'),
      backgroundColor: const Color.fromRGBO(35, 131, 51, 1.0),
    ),
    body: SingleChildScrollView(
      child: Center(
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
              const SizedBox(height: 20),
              const Text(
                'Informações do Time',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text(
                  'Nome Popular',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  teamData['nome_popular'],
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text(
                  'Posição',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  teamData['posicao'],
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text(
                  'Pontos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  teamData['pontos'],
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text(
                  'Sigla',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  teamData['sigla'],
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Você selecionou o clube ${teamData['nome_popular']}, que atualmente está na ${teamData['posicao']}ª colocação com ${teamData['pontos']} pontos. Para saber mais informações sobre o time selecionado, procure pelo site oficial do clube.',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}




}
