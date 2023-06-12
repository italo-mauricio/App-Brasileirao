import 'package:flutter/material.dart';

class FasesCopaWidget extends StatelessWidget {
  final List<Map<String, dynamic>> jsonObjects;

  const FasesCopaWidget({Key? key, required this.jsonObjects}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (jsonObjects == null) {
      // Exibir uma mensagem ou widget de carregamento enquanto aguarda os dados da API
      return CircularProgressIndicator();
    }

    // Encontre a fase atual com base em alguma lógica
    int faseAtualIndex = 0; // Exemplo: A primeira fase é considerada a fase atual

    var faseAtual = jsonObjects[faseAtualIndex];
    String faseId = faseAtual['fase_id'].toString();
    String nome = faseAtual['nome'];
    String tipo = faseAtual['tipo'];
    String proximaFaseNome = faseAtual['proxima_fase_nome'];

    List<Map<String, dynamic>> confrontos = faseAtual['confrontos'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Fase ID: $faseId'),
        Text('Nome: $nome'),
        Text('Tipo: $tipo'),
        Text('Próxima Fase: $proximaFaseNome'),
        const SizedBox(height: 8),
        Text('Confrontos:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
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
    );
  }
}
