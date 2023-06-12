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

enum DescripitonStatus { idle, loading, ready, error }

class DataService {
  final ValueNotifier<Map<String, dynamic>> tableStateNotifier = ValueNotifier({
    'status': TableStatus.idle,
    'dataObjects': [],
    'columnNames': [],
    'propertyNames': []
  });
  final ValueNotifier<Map<String, dynamic>> descriptionNotifier =
      ValueNotifier({'status': DescripitonStatus.loading, 'data': {}});

  late int rodada;

  void chamarApi(index) {
    final requisicoes = [tabela, partidas, print, print];
    tableStateNotifier.value = {'status': TableStatus.loading};
    requisicoes[index]();
  }

  Future<void> partidas() async {
    var key = auths();
    var recRodada = Uri(
        scheme: 'https',
        host: 'api.api-futebol.com.br',
        path: 'v1/campeonatos/10/');

    try {
      var jsonString =
          await http.read(recRodada, headers: {'Authorization': key});
      dynamic partidasJson = jsonDecode(jsonString);
      rodada = partidasJson["rodada_atual"]["rodada"];
      var recPartidas = Uri(
          scheme: 'https',
          host: 'api.api-futebol.com.br',
          path: 'v1/campeonatos/10/rodadas/$rodada');
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
            'partida': p["partida_id"]
          };
        }).toList();
        tableStateNotifier.value = {
          'status': TableStatus.readyMatches,
          'dataObjects': matchesJson,
          'utils': rodada,
        };
      } catch (e) {
        print(e);
        tableStateNotifier.value = {'status': TableStatus.error};
      }
    } catch (e) {
      print(e);
      tableStateNotifier.value = {'status': TableStatus.error};
    }
  }

  Future<void> partidasR(int rodadas) async {
    var key = auths();
    var recPartidas = Uri(
        scheme: 'https',
        host: 'api.api-futebol.com.br',
        path: 'v1/campeonatos/10/rodadas/$rodada');
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
          'partida': p["partida_id"]
        };
      }).toList();
      tableStateNotifier.value = {
        'status': TableStatus.readyMatches,
        'dataObjects': matchesJson,
        'utils': rodada
      };
    } catch (e) {
      print(e);
      tableStateNotifier.value = {'status': TableStatus.error};
    }
  }

  Future<void> descricaoPartidas(int partidaId) async {
    var key = auths();
    var recDescription = Uri(
        scheme: 'https',
        host: 'api.api-futebol.com.br',
        path: '/v1/partidas/$partidaId');
    try {
      descriptionNotifier.value = {
        'status': DescripitonStatus.loading
      };
      var descriptionString =
          await http.read(recDescription, headers: {'Authorization': key});
      Map<String, dynamic> p = jsonDecode(descriptionString);
      final descriptionJson = {
        'status': p["status"],
        'local': p["estadio"]["nome_popular"],
        'gols_m': p["gols"]["mandante"],
        'gols_v': p["gols"]["visitante"],
      };
      descriptionNotifier.value = {
        'status': DescripitonStatus.ready,
        'data': descriptionJson,
      };
    } catch (e) {
      print(e);
      descriptionNotifier.value = {'status': DescripitonStatus.error};
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
}

final dataService = DataService();
