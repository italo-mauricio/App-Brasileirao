import 'package:flutter/material.dart';

class FasesCopaWidget extends StatelessWidget {
  final List<Map<String, dynamic>> jsonObjects;

  const FasesCopaWidget({Key? key, required this.jsonObjects}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: jsonObjects.length,
      itemBuilder: (BuildContext context, int index) {
        var object = jsonObjects[index];

        String faseId = object['fase_id'].toString();
        String nome = object['nome'];
        String tipo = object['tipo'];
        String proximaFaseNome = object['proxima_fase']['nome'];

        List<Map<String, dynamic>> confrontos = object['confrontos'];

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Fase ID: $faseId'),
                Text('Nome: $nome'),
                Text('Tipo: $tipo'),
                Text('Próxima Fase: $proximaFaseNome'),
                SizedBox(height: 8),
                Text('Confrontos:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: confrontos.length,
                  itemBuilder: (context, index) {
                    var confronto = confrontos[index];
                    String time1 = confronto['time1'];
                    String time2 = confronto['time2'];
                    String resultado = confronto['resultado'];

                    return ListTile(
                      title: Text('$time1 vs $time2'),
                      subtitle: Text('Resultado: $resultado'),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


