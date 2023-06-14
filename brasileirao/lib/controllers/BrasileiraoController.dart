import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../sections/ChaviamentoCopa.dart';
import 'package:brasileirao/sections/Table.dart';
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

enum DescripitonStatus { idle, loading, ready, error }

class DataService {
  final ValueNotifier<Map<String, dynamic>> tableStateNotifier = ValueNotifier({
    'status': TableStatus.idle,
    'dataObjects': [],
    'columnNames': [],
    'propertyNames': []
  });
  final ValueNotifier<Map<String, dynamic>> descriptionNotifier =
      ValueNotifier({
    'status': DescripitonStatus.idle,
    'data': {'partidaId': -1}
  });

  late int rodada;
  int _selectedPartidaId = -1;

  get selectedPartidaId => _selectedPartidaId;

  void chamarApi(index) {
    final requisicoes = [tabela, partidas, chaviamento, print];
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

  void partidaAnterior() {
    rodada--;
    _selectedPartidaId = -1;
    partidasR();
  }

  void partidaPosterior() {
    rodada += 5;
    _selectedPartidaId = -1;
    partidasR();
  }

  Future<void> partidasR() async {
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
          'sigla_mandante':
              p["time_mandante"]["sigla"] ?? "Nome Indisponivel no momento",
          'time_mandante': p["time_mandante"]["escudo"] ??
              "https://portal.crea-sc.org.br/wp-content/uploads/2017/11/imagem-indisponivel-para-produtos-sem-imagem_15_5.jpg",
          'sigla_visitante':
              p["time_visitante"]["sigla"] ?? "Nome Indisponivel no momento",
          'time_visitante': p["time_visitante"]["escudo"] ??
              "https://portal.crea-sc.org.br/wp-content/uploads/2017/11/imagem-indisponivel-para-produtos-sem-imagem_15_5.jpg",
          'data': p["data_realizacao"] ?? "Indefinida",
          'hora': p["hora_realizacao"] ?? "Indefinido",
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
    _selectedPartidaId = partidaId;

    var key = auths();
    var recDescription = Uri(
        scheme: 'https',
        host: 'api.api-futebol.com.br',
        path: '/v1/partidas/$partidaId');
    try {
      descriptionNotifier.value = {'status': DescripitonStatus.loading};
      var descriptionString =
          await http.read(recDescription, headers: {'Authorization': key});
      Map<String, dynamic> p = jsonDecode(descriptionString);
        String local;
         if (p["estadio"] != null) {
             local = p["estadio"]["nome_popular"];
         } else {
           local = "Local Indefinido"; 
         }
      final descriptionJson = {
        'partidaId': partidaId,
        'status': p["status"] ?? "Status Indefinido",
        'local': local,
        'gols_m': p["gols"]["mandante"] ?? "Gols Indefinidos",
        'gols_v': p["gols"]["visitante"] ?? "Gols Indefinidos",
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

  Future<void> chaviamento() async {
    var key = auths();
    var recFasesCopa = Uri(
      scheme: 'https',
      host: 'api.api-futebol.com.br',
      path: 'v1/campeonatos/2/fases',
    );

    try {
      var jsonString =
          await http.read(recFasesCopa, headers: {'Authorization': key});
      var tabelaJson = jsonDecode(jsonString);

      // Acessa a lista de fases da Copa do Brasil
      List<dynamic> fasesCopaBrasil = tabelaJson['fases'];

      // Cria uma lista de Map para armazenar as informações tratadas
      List<Map<String, dynamic>> times = [];
      fasesCopaBrasil.forEach((item) {
        int faseId = item['fase_id'];
        String nomePopular = item['nome_popular'];
        String nome = item['nome'];
        String temporada = item['edicao']['temporada'];
        String slug = item['slug'];

        // Acessa as informações dos confrontos
        List<dynamic> confrontos = item['chaves'];
        List<String> chaves =
            confrontos.map<String>((confronto) => confronto['_link']).toList();

        Map<String, dynamic> timeData = {
          'fase_id': faseId.toString(),
          'nome_popular': nomePopular,
          'nome': nome,
          'slug': slug,
          'chaves': chaves
        };
        times.add(timeData);
      });

      List<String> columnNames = [
        'Fase ID',
        'Nome Popular',
        'Nome',
        'Temporada',
        'Slug',
        'Chaves'
      ];

      List<String> propertyNames = [
        'fase_id',
        'nome_popular',
        'nome',
        'temporada',
        'slug',
        'chaves'
      ];

      tableStateNotifier.value = {
        'status': TableStatus.readyPhase,
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
