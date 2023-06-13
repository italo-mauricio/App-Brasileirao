import 'package:flutter/material.dart';

class FasesCopaWidget extends StatelessWidget {
  final Map<String, dynamic> jsonObjects;

  const FasesCopaWidget({Key? key, required this.jsonObjects}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fases da Copa do Brasil'),
      ),
      body: ListView.builder(
        itemCount: jsonObjects['fases'].length,
        itemBuilder: (context, index) {
          final fase = jsonObjects['fases'][index];
          final faseNome = fase['nome'];
          final chaves = fase['chaves'];

          return ExpansionTile(
            title: Text(faseNome),
            children: [
              for (var chave in chaves) ...[
                ListTile(
                  title: Text('Chave ${chave['nome']}'),
                  subtitle: Column(
                    children: [
                      for (var time in chave['times'])
                        Text(time['nome_popular']),
                    ],
                  ),
                ),
                Divider(),
              ],
            ],
          );
        },
      ),
    );
  }
}