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
    final requisicoes = [print, partidas, artilheiro];
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
            'sigla_mandante':p["time_mandante"]["sigla"],
            'time_mandante':p["time_mandante"]["escudo"],
            'sigla_visitante':p["time_visitante"]["sigla"],
            'time_visitante':p["time_visitante"]["escudo"],
            'data':p["data_realizacao"],
            'hora':p["hora_realizacao"],
            'local': p["estadio"]["nome_popular"]
          };
        }).toList();
        tableStateNotifier.value = {
          'status': TableStatus.readyMatches,
          'dataObjects': matchesJson,
          'columnNames': ["Jogo", "Casa","escudoCasa","fora","escudoFora","data","hora","local"],
          'propertyNames': ["placar", 'sigla_mandante','time_mandante','sigla_visitante','time_visitante','data','hora','local']
        };
      } catch (e) {
        tableStateNotifier.value = {'status': TableStatus.error};
      }
    } catch (e) {
      tableStateNotifier.value = {'status': TableStatus.error};
    }
  }

Future<void> artilheiro() async {
  var key = auths();
  var artil = Uri(
    scheme: 'https',
    host: 'api.api-futebol.com.br',
    path: 'v1/campeonatos/10/artilharia',
  );

  try {
    var response = await http.head(artil, headers: {'Authorization': key});
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      List artMatchesJson = jsonData.map((p) {
        return {
          'atleta': p['atleta']['nome_popular'],
          'time': p['time']['nome_popular'],
          'escudo': p['time']['escudo'],
          'gols': p['gols'],
        };
      }).toList();

      tableStateNotifier.value = {
        'status': TableStatus.readyMatches,
        "dataObjects": artMatchesJson,
        'columnNames': ["Atleta", "Time", "Escudo", "Gols"],
        'propertyNames': ["atleta", "time", "escudo", "gols"],
      };
    } else {
      print('Erro na requisição: ${response.statusCode}');
      tableStateNotifier.value = {'status': TableStatus.error};
    }
  } catch (e) {
    print('Exceção durante a requisição: $e');
    tableStateNotifier.value = {'status': TableStatus.error};
  }
}

}