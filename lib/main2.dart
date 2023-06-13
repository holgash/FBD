import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<int> obterValorSprint(int id) async {
  try {
    // Ler o conteúdo do arquivo JSON
    String jsonData = await rootBundle.loadString('assets/sprint.json');

    // Decodificar o conteúdo JSON
    var data = jsonDecode(jsonData);

    // Procurar o projeto com o ID fornecido
    var projeto = data['projetos']
        .firstWhere((projeto) => projeto['id'] == id, orElse: () => null);

    // Verificar se o projeto foi encontrado
    if (projeto != null) {
      // Obter o array de dados do projeto
      var dados = projeto['dados'];

      // Verificar se o array de dados não está vazio
      if (dados.isNotEmpty) {
        // Obter o último elemento do array de dados
        var ultimoElemento = dados.last;

        // Obter o valor da sprint do último elemento
        var valorSprint = ultimoElemento['sprint'];

        // Retornar o valor da sprint
        return valorSprint;
      }
    }
  } catch (e) {
    print('Erro ao ler o arquivo JSON: $e');
  }

  // Retornar 0 caso ocorra algum erro ou o projeto não seja encontrado
  return 0;
}

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Garante a inicialização do Flutter
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exemplo de Leitura de JSON',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Exemplo de Leitura de JSON'),
        ),
        body: Center(
          child: FutureBuilder<int?>(
            future: obterValorSprint(
                5), // ID do projeto que deseja obter o valor da sprint
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text(
                      'Erro ao obter o valor da sprint: ${snapshot.error}');
                } else {
                  int? valorSprint = snapshot.data;
                  if (valorSprint != null) {
                    return Text(
                        'O valor da sprint do projeto com ID 1 é $valorSprint');
                  } else {
                    return Text(
                        'Projeto não encontrado ou array de dados vazio');
                  }
                }
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
