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
    final requisicoes = [partidas];
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
        path: 'v1/campeonatos/10/rodadas');
    try {
      var jsonString = await http
          .read(recPartidas, headers: {'Authorization': key});
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

}