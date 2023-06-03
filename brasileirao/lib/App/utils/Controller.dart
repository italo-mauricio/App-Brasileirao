import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum TableStatus { idle, loading, ready, readyTable, readyPlayers, readyMatches, error }
class DataService {
  final ValueNotifier<Map<String, dynamic>> tableStateNotifier =
      ValueNotifier({'status': TableStatus.idle, 'dataObjects': []});
  final ValueNotifier<List<String>> columnsNamesNotifier = ValueNotifier([]);
  final ValueNotifier<List<String>> propetyNamesNotifier = ValueNotifier([]);

  void chamarApi(index) {
    final requisicoes = [partidas];
    tableStateNotifier.value = {
      'status': TableStatus.loading,
      'dataObjects': [],
    };
    requisicoes[index]();
  }

// https://api.api-futebol.com.br/v1/campeonatos/10/rodadas/8
  Future<void> partidas() async {
    var recPartidas = Uri(
        scheme: 'https',
        host: 'api.api-futebol.com.br',
        path: 'v1/campeonatos/10/rodadas/8');
    try {
      var jsonString = await http.read(recPartidas, headers: {
        'Authorization': 'Bearer live_b8af81619c2465683b1395abe5568b'
      });
      var partidasJson = jsonDecode(jsonString)["partidas"];
      // print(partidasJson);
      tableStateNotifier.value = {
        'status': TableStatus.readyMatches,
        'dataObjects': partidasJson,
      };
      propetyNamesNotifier.value = ["placar"];
      columnsNamesNotifier.value = ["Placar"];
    } catch (e) {
      tableStateNotifier.value = {
        'status': TableStatus.error,
        'dataObjects': []
      };
    }
  }

}
