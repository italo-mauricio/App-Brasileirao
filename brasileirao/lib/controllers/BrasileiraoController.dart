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
  readyPhase,
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
    final requisicoes = [tabela, partidas, fasesCopa, print];
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

   Future<void> fasesCopa() async {
    var key = auths();
    var recFases = Uri(
      scheme: 'https',
      host: 'api.api-futebol.com.br',
      path: 'v1/campeonatos/2/fases',
    );

    try {
      var jsonString = await http.read(recFases, headers: {'Authorization': key});
      var tabelaJson = jsonDecode(jsonString);

      List<dynamic> fasesCopaBrasil = tabelaJson as List<dynamic>;

      List<Map<String, dynamic>> fasesEdicao = [];
      fasesCopaBrasil.forEach((item) {
        int faseId = item['fase_id'];
        Map<int, dynamic> timeInfo = item[faseId];
        int edicaoId = item['edicao_id'];
        String temporada = timeInfo['temporada'];
        String nome = timeInfo['nome'];
        String nomePopular = timeInfo['nome_popular'];
        String slug = timeInfo['slug'];
        Map<String, dynamic> edicaoData = {
          'fase_id': faseId.toString(),
          'edicao_id': edicaoId.toString(),
          'temporada': temporada,
          'nome': nome,
          'nome_popular': nomePopular,
          'slug': slug,
        };

        List<dynamic> jogos = item['jogos'];
        List<Map<String, dynamic>> confrontos = [];
        jogos.forEach((jogo) {
          String time1 = jogo['time1'];
          String time2 = jogo['time2'];
          String resultado = jogo['resultado'];
          Map<String, dynamic> confronto = {
            'time1': time1,
            'time2': time2,
            'resultado': resultado,
          };
          confrontos.add(confronto);
        });

        edicaoData['confrontos'] = confrontos;

        fasesEdicao.add(edicaoData);
      });

      List<String> columnNames = [
        'Fase_id',
        'Edicao_id',
        'Temporada',
        'Nome',
        'Nome Popular',
        'SLug'
      ];

      List<String> propertyNames = [
        'fase_id',
        'edicao_id',
        'temporada',
        'nome',
        'nome_popular',
        'slug',
      ];

      tableStateNotifier.value = {
        'status': TableStatus.readyTable,
        'dataObjects': fasesEdicao,
        'columnNames': columnNames,
        'propertyNames': propertyNames,
      };
    } catch (e) {
      tableStateNotifier.value = {'status': TableStatus.error};
    }
  }

}
