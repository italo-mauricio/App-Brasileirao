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
  readyPlayers,
  readyMatches,
  error
}

class DataService {
  final ValueNotifier<Map<String, dynamic>> tableStateNotifier =
      ValueNotifier({'status': TableStatus.idle, 'dataObjects': []});
  final ValueNotifier<List<String>> columnsNamesNotifier = ValueNotifier([]);
  final ValueNotifier<List<String>> propetyNamesNotifier = ValueNotifier([]);

  void chamarApi(index) {
    // ignore: avoid_print
    final requisicoes = [tabela, partidas];
    tableStateNotifier.value = {
      'status': TableStatus.loading,
      'dataObjects': [],
    };
    requisicoes[index]();
  }

// https://api.api-futebol.com.br/v1/campeonatos/10/rodadas/8
  Future<void> partidas() async {
    var key = auths();
    // int rodadas = 8;
    // var recPartidas = Uri(
    //     scheme: 'https',
    //     host: 'api.api-futebol.com.br',
    //     path: 'v1/campeonatos/10/rodadas/$rodadas');
    // https://api.api-futebol.com.br/v1/campeonatos/10/rodadas
    var recPartidas = Uri(
        scheme: 'https',
        host: 'api.api-futebol.com.br',
        path: 'v1/campeonatos/10/rodadas/8');
    try {
      var jsonString =
          await http.read(recPartidas, headers: {'Authorization': key});
      List partidasJson = jsonDecode(jsonString);
      var rodada = partidasJson.firstWhere((p) => p["status"] == "agendada");
      print(rodada["rodada"]);
      tableStateNotifier.value = {
        'status': TableStatus.readyMatches,
        'dataObjects': [rodada],
      };
      propetyNamesNotifier.value = ["nome"];
      columnsNamesNotifier.value = ["Nome"];
    } catch (e) {
      print(e);
      tableStateNotifier.value = {
        'status': TableStatus.error,
        'dataObjects': []
      };
    }
  }

  Future<void> tabela() async {
    var key = auths();
    var recTabela = Uri(
        scheme: 'https',
        host: 'api.api-futebol.com.br',
        path: 'v1/campeonatos/10/tabela');
    try {
      var jsonString =
          await http.read(recTabela, headers: {'Authorization': key});
      var tabelaJson = jsonDecode(jsonString);

      // transformo toda a tabela de classificação em uma lista dynamic
      List<dynamic> classificacao = tabelaJson as List<dynamic>;

      // jogo tudo num Map
      List<Map<String, dynamic>> times = [];
      classificacao.forEach((item) {
        int posicao = item['posicao'];   // passo pra inteiro todas as posições que forem int na API, tipo posição, pontos e tal
        int pontos = item['pontos'];
        Map<String, dynamic> timeInfo = item['time'];
        // seto normalmente o que eu quero apresentar da tabela
        int timeId = timeInfo['time_id'];
        String nomePopular = timeInfo['nome_popular'];
        String sigla = timeInfo['sigla'];
        String escudo = timeInfo['escudo'];

        Map<String, dynamic> timeData = {
          'posicao': posicao.toString(),   // uso o toString pra fazer a conversão pra string
          'pontos': pontos.toString(),
          'time_id': timeId.toString(),
          'nome_popular': nomePopular,
          'sigla': sigla,
          'escudo': escudo,
        };
        times.add(timeData);
      });
      print(times);
      // e aqui exibo todas as informações convertidas
      tableStateNotifier.value = {
        'status': TableStatus.readyTable,
        'dataObjects': times,
      };
      propetyNamesNotifier.value = [
        "posicao",
        "pontos",
        "time_id",
        "nome_popular",
        "sigla",
        "escudo"
      ];
      columnsNamesNotifier.value = [
        "Posição",
        "Pontos",
        "Time ID",
        "Nome Popular",
        "Sigla",
        "Escudo"
      ];
    } catch (e) {
      tableStateNotifier.value = {
        'status': TableStatus.error,
        'dataObjects': []
      };
    }
  }
}
