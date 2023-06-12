import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/keysAuth.dart';

enum TableStatus {
  idle,
  loading,
  ready,
  readyTable,
  readyRound,
  readyPlayers,
  readyMatches,
  error
}

class DataService {
  final ValueNotifier<Map<String, dynamic>> tableStateNotifier = ValueNotifier({
    'status': TableStatus.idle,
    'dataObjects': [],
    'columnNames': [],
    'propertyNames': []
  });

  void chamarApi(index) {
    final requisicoes = [tabela, partidas, chaveamento, print];
    tableStateNotifier.value = {'status': TableStatus.loading};
    requisicoes[index]();
  }

  Future<void> partidas() async {
    var key = auths();
    var recRodada = Uri(
        scheme: 'https',
        host: 'api.api-futebol.com.br',
        path: 'v1/campeonatos/10/rodadas');

    try {
      var jsonString =
          await http.read(recRodada, headers: {'Authorization': key});
      List partidasJson = jsonDecode(jsonString);
      var rodada = partidasJson.firstWhere((p) => p["status"] == "agendada");
      tableStateNotifier.value = {
        'status': TableStatus.readyRound,
        'round': rodada,
        'columnNames': [],
        'propertyNames': []
      };

      var numRodada = rodada["rodada"];
      var recPartidas = Uri(
          scheme: 'https',
          host: 'api.api-futebol.com.br',
          path: 'v1/campeonatos/10/rodadas/$numRodada');

      try {
        var matchesString =
            await http.read(recPartidas, headers: {'Authorization': key});

        List matchesJson = jsonDecode(matchesString)["partidas"].map((p) {
          return {
            'placar': p["placar"],
            'sigla_mandante': p["time_mandante"]["sigla"],
            'time_mandante': p["time_mandante"]["escudo"],
            'sigla_visitante': p["time_visitante"]["sigla"],
            'time_visitante': p["time_visitante"]["escudo"],
            'data': p["data_realizacao"],
            'hora': p["hora_realizacao"],
            'local': p["estadio"]["nome_popular"]
          };
        }).toList();
        tableStateNotifier.value = {
          'status': TableStatus.readyMatches,
          'dataObjects': matchesJson,
          'columnNames': [
            "Jogo",
            "Casa",
            "escudoCasa",
            "fora",
            "escudoFora",
            "data",
            "hora",
            "local"
          ],
          'propertyNames': [
            "placar",
            'sigla_mandante',
            'time_mandante',
            'sigla_visitante',
            'time_visitante',
            'data',
            'hora',
            'local'
          ]
        };
      } catch (e) {
        tableStateNotifier.value = {'status': TableStatus.error};
      }
    } catch (e) {
      tableStateNotifier.value = {'status': TableStatus.error};
    }
  }

  Future<void> tabela() async {
    var key = auths();
    var recTabela = Uri(
      scheme: 'https',
      host: 'api.api-futebol.com.br',
      path: 'v1/campeonatos/10/tabela',
    );

    try {
      var jsonString =
          await http.read(recTabela, headers: {'Authorization': key});
      var tabelaJson = jsonDecode(jsonString);

      // Transforma toda a tabela de classificação em uma lista dynamic
      List<dynamic> classificacao = tabelaJson as List<dynamic>;

      // Cria uma lista de Map para armazenar as informações tratadas
      List<Map<String, dynamic>> times = [];
      classificacao.forEach((item) {
        int posicao = item['posicao'];
        int pontos = item['pontos'];
        Map<String, dynamic> timeInfo = item['time'];
        String nomePopular = timeInfo['nome_popular'];
        String sigla = timeInfo['sigla'];
        String escudoUrl = timeInfo['escudo'];
        Map<String, dynamic> timeData = {
          'posicao': posicao.toString(),
          'pontos': pontos.toString(),
          'nome_popular': nomePopular,
          'sigla': sigla,
          'escudo': escudoUrl,
        };
        times.add(timeData);
      });

      List<String> columnNames = [
        'Posição',
        'Pontos',
        'Nome Popular',
        'Sigla',
        'Escudo'
      ];

      List<String> propertyNames = [
        'posicao',
        'pontos',
        'nome_popular',
        'sigla',
        'escudo'
      ];

      tableStateNotifier.value = {
        'status': TableStatus.readyTable,
        'dataObjects': times,
        'columnNames': columnNames,
        'propertyNames': propertyNames,
      };
    } catch (e) {
      tableStateNotifier.value = {'status': TableStatus.error};
    }
  }



Future<void> chaveamento() async {
  var key = auths();
  var recChaveamento = Uri(
    scheme: 'https',
    host: 'api.api-futebol.com.br',
    path: 'v1/campeonatos/2',
  );

  try {
    var jsonString = await http.read(recChaveamento, headers: {'Authorization': key});
    var fasesJson = jsonDecode(jsonString);
    var fases = fasesJson['fases'];

    List<Map<String, dynamic>> rodadas = [];

    if (fases != null && fases.isNotEmpty) {
      // Procurar a fase "Quartas de Final"
      var quartasDeFinal = fases.firstWhere((fase) => fase['nome'] == 'Quartas de Final', orElse: () => null);
      if (quartasDeFinal != null) {
        var chaves = quartasDeFinal['fase_id'];

        for (var chave in chaves) {
          var partidas = chave['partidas'];

          for (var partida in partidas) {
            var status = partida['status'];
            if (status != 'agendado') continue;

            var timeMandante = partida['time_mandante'];
            var timeVisitante = partida['time_visitante'];
            var estadio = partida['estadio'];

            var placar = partida['placar'];
            var nomeMandante = timeMandante['nome'];
            var nomeVisitante = timeVisitante['nome'];
            var escudoMandante = timeMandante['escudo'];
            var escudoVisitante = timeVisitante['escudo'];
            var nomeEstadio = estadio['nome'];

            var rodadaData = {
              'placar': placar,
              'nome_mandante': nomeMandante,
              'escudo_mandante': escudoMandante,
              'nome_visitante': nomeVisitante,
              'escudo_visitante': escudoVisitante,
              'nome_estadio': nomeEstadio,
            };

            rodadas.add(rodadaData);
          }
        }
      }
    }

    if (rodadas.isNotEmpty) {
      tableStateNotifier.value = {
        'status': TableStatus.ready,
        'dataObjects': rodadas,
        'columnNames': ['Placar', 'Mandante', 'Visitante', 'Estádio'],
        'propertyNames': ['placar', 'nome_mandante', 'nome_visitante', 'nome_estadio'],
      };
    } else {
      print('Nenhuma rodada encontrada');
      print('JSON: $jsonString');
      tableStateNotifier.value = {'status': TableStatus.error};
    }
  } catch (e) {
    print('Erro ao obter o chaveamento: $e');
    tableStateNotifier.value = {'status': TableStatus.error};
  }
}





}
