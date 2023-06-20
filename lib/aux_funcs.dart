import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'detailedScore.dart';

//função auxiliar que invoca as outras funções necessárias
generateScores(DetailedScore ds) {
  categoryScore auxScores = categoryScore();
  auxScores.usdScore = generateUSDScore(ds);
  auxScores.bmScore = generateBMScore(ds);
  auxScores.qcScore = generateQCScore(ds);

  return auxScores;
}

//lógica para gerar a nota da aba USD
int generateUSDScore(DetailedScore ds) {
  int score = 0;

  //USS 10%
  if (ds.userStoryDefinitionScore.USS['OTE1']! == 0) {
    score += 5;
  }
  if (ds.userStoryDefinitionScore.USS['OTE2']! <= 10) {
    score += 5;
  }
  //AC 10% e DR 5%
  if (ds.userStoryDefinitionScore.SUS1.acceptanceCriteria == true &&
      ds.userStoryDefinitionScore.SUS2.acceptanceCriteria == true &&
      ds.userStoryDefinitionScore.SUS3.acceptanceCriteria == true) {
    score += 10;
  } else if (ds.userStoryDefinitionScore.SUS1.acceptanceCriteria == false &&
      ds.userStoryDefinitionScore.SUS2.acceptanceCriteria == false &&
      ds.userStoryDefinitionScore.SUS3.acceptanceCriteria == false) {
    score += 0;
  } else {
    score += 5;
  }
  if (ds.userStoryDefinitionScore.SUS1.definitionOfReady == true &&
      ds.userStoryDefinitionScore.SUS2.definitionOfReady == true &&
      ds.userStoryDefinitionScore.SUS3.definitionOfReady == true) {
    score += 5;
  } else if (ds.userStoryDefinitionScore.SUS1.definitionOfReady == false &&
      ds.userStoryDefinitionScore.SUS2.definitionOfReady == false &&
      ds.userStoryDefinitionScore.SUS3.definitionOfReady == false) {
    score += 0;
  } else {
    score += 3;
  }

  return score;
}

//lógica para gerar a nota da aba BM
int generateBMScore(DetailedScore ds) {
  int score = 0;
  //SGD 5%
  if (ds.boardManagementScore.SGD == true) {
    score += 5;
  }

  //BP 10%
  if (ds.boardManagementScore.bpScore.high > 80 &&
      ds.boardManagementScore.bpScore.medium == 100) {
    score += 0;
  } else {
    if (ds.boardManagementScore.bpScore.prioritized) {
      score += 10;
    } else {
      score += 0;
    }
  }

  //Defects 5%
  if (ds.boardManagementScore.defects.classified == true &&
      ds.boardManagementScore.defects.estimated == true &&
      ds.boardManagementScore.defects.prioritized == true) {
    score += 5;
  } else if (ds.boardManagementScore.defects.classified == false &&
      ds.boardManagementScore.defects.estimated == false &&
      ds.boardManagementScore.defects.prioritized == false) {
    score += 0;
  } else {
    score += 3;
  }

  //FE+Design 5%
  if (ds.boardManagementScore.feDesign.FE != 0 &&
      ds.boardManagementScore.feDesign.design != 0) {
    score += 5;
  } else if (ds.boardManagementScore.feDesign.FE == 0 &&
      ds.boardManagementScore.feDesign.design == 0) {
    score += 0;
  } else {
    score += 3;
  }
  return score;
}

//lógica para gerar a nota da aba QC
int generateQCScore(DetailedScore ds) {
  int score = 0;
  //SD 15%
  if (ds.qualityControlScore.sprintDefinition >= 90) {
    score += 15;
  } else if (ds.qualityControlScore.sprintDefinition >= 85) {
    score += 10;
  } else if (ds.qualityControlScore.sprintDefinition >= 50) {
    score += 5;
  } else {
    score += 0;
  }

  //IE 15%
  if (ds.qualityControlScore.issueEstimation == 100) {
    score += 15;
  } else if (ds.qualityControlScore.issueEstimation >= 85) {
    score += 10;
  } else if (ds.qualityControlScore.issueEstimation >= 75) {
    score += 5;
  } else {
    score += 0;
  }

  //PE 10%
  if (ds.qualityControlScore.projectExecution >= 95) {
    score += 10;
  } else if (ds.qualityControlScore.projectExecution >= 85) {
    score += 8;
  } else if (ds.qualityControlScore.projectExecution >= 75) {
    score += 5;
  } else {
    score += 0;
  }

  //# of bugs
  if (ds.qualityControlScore.numBugs.coverage <= 0.5) {
    score += 0;
  } else {
    double ratio = ds.qualityControlScore.numBugs.numBugs /
        ds.qualityControlScore.numBugs.numStories;
    if (ratio <= 0.5) {
      score += 10;
    } else if (ratio <= 2) {
      score += 8;
    } else if (ratio <= 3) {
      score += 5;
    } else {
      score += 0;
    }
  }
  return score;
}

//gerar a cor apropriada baseada no score passado
Color getProgressColor(double score, {double? threshold1, double? threshold2}) {
  if (threshold1 != null && threshold2 != null) {
    if (score < threshold1) {
      return Colors.red;
    } else if (score < threshold2) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  } else {
    if (score < 0.5) {
      return Colors.red;
    } else if (score < 0.7) {
      return Color.fromRGBO(251, 192, 45, 1);
    } else {
      return Colors.green;
    }
  }
}

//ler o arquivo de entrada para obter o valor da sprint mais recente daquele projeto
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

//ler o arquivo de entrada para obter os membros daquele projeto
Future<List<Map<String, String>>> getMembersFromJson(int id) async {
  List<Map<String, String>> members = [];

  // Ler o conteúdo do arquivo JSON
  String jsonData = await rootBundle.loadString('assets/projects.json');

  // Converter o JSON em um objeto Dart
  dynamic data = jsonDecode(jsonData);

  // Encontrar o projeto com o ID fornecido
  Map<String, dynamic>? project = data['projetos']
      .firstWhere((proj) => proj['id'] == id, orElse: () => null);

  // Verificar se o projeto foi encontrado
  if (project != null) {
    // Obter a lista de membros do projeto
    List<dynamic> membersData = project['members'];

    members = membersData.map<Map<String, String>>((member) {
      String name = member['name'];
      String role = member['role'];
      return {'name': name, 'role': role};
    }).toList();
  }

  return members;
}

//gerar um widget customizado para evitar tanto copiar e colar
Widget generateContainer(String text1, String text2, String text3,
    [String? optionalText]) {
  Color circleColor;

  if (text2 == "penalty") {
    circleColor = Colors.red;
  } else if (text2 == "partially") {
    circleColor = Colors.yellow;
  } else if (text2 == "No penalty") {
    circleColor = Colors.green;
  } else {
    circleColor = Colors.transparent;
  }

  return Container(
    padding: EdgeInsets.all(16.0),
    child: Row(
      children: [
        Expanded(
          child: Text(
            text1,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
        SizedBox(width: 8.0),
        CircleAvatar(
          radius: 8.0,
          backgroundColor: circleColor,
        ),
        SizedBox(width: 8.0),
        Expanded(
          child: Text(
            text3,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
        if (optionalText != null && optionalText.isNotEmpty) ...[
          SizedBox(width: 8.0),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            width: 100.0, // Defina o tamanho fixo desejado aqui
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                optionalText,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        ],
      ],
    ),
  );
}

//gerar o 2 tipo de widget customizado
Widget buildValueRectangle(String text, double? value, String? optionalText) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black),
    ),
    child: Center(
      child: Text(
        text + (value != null ? value.toString() : '') + (optionalText ?? ''),
        style: TextStyle(fontSize: 16.0),
      ),
    ),
  );
}

//gerar o texto da barra de progresso
Widget buildProgressTabText(
  String sizeTitle,
  String sizeDescription,
) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.0),
        Text(
          sizeTitle,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        Text(
          sizeDescription,
          style: TextStyle(fontSize: 16.0),
        ),
      ],
    ),
  );
}

//gerar o widget da barra de progresso
Widget buildProgressTabIndicator(
    double progressValue, double progressTotal, String title,
    {double? optionalParam1, double? optionalParam2}) {
  double progressRatio = progressValue / progressTotal;
  Color progressColor = getProgressColor(progressRatio,
      threshold1: optionalParam1, threshold2: optionalParam2);

  return Container(
    padding: EdgeInsets.all(16.0),
    child: Column(
      children: [
        SizedBox(height: 16.0),
        Text(
          title,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        LinearProgressIndicator(
          value: progressRatio,
          valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          backgroundColor: Colors.grey[300],
        ),
        SizedBox(height: 8.0),
        Text(
          '${(progressValue.toInt())}/${(progressTotal.toInt())}',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
