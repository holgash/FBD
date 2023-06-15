import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'aux_funcs.dart';
import 'detailedScore.dart';
import 'linear_charts.dart';
import 'dart:convert';

class ProjectDetailsPage extends StatefulWidget {
  final String projectName;
  final String projectType;
  final int projectId;

  Future<DetailedScore>? detailedScore;

  ProjectDetailsPage(this.projectName, this.projectType, this.projectId) {
    //detailedScore = parseDetailedScore(projectId);
  }

  @override
  _ProjectDetailsPageState createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  bool _isExpandedTop = false;
  bool _isExpandedUserStory = false;
  bool _isExpandedBoardManagement = false;
  bool _isExpandedQualityControl = false;

  int sprintValue = 0;

  List<Map<String, String>> members = [];

  late Future<DetailedScore> detailedScore;

  late DetailedScore ds;

  late categoryScore categoryScores =
      categoryScore(usdScore: 0, bmScore: 0, qcScore: 0);

  @override
  void initState() {
    super.initState();

    fetchDetailedScore();
    fetchMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.projectName),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpandedTop = !_isExpandedTop;
                });
              },
              child: Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 120.0,
                          child: Text(
                            "Audit score:\n${categoryScores.usdScore + categoryScores.bmScore + categoryScores.qcScore}/100",
                            style: TextStyle(fontSize: 18.0),
                            //textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          width: 24.0,
                          height: 24.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (categoryScores.usdScore +
                                            categoryScores.bmScore +
                                            categoryScores.qcScore) /
                                        100 >=
                                    0.7
                                ? Colors.green
                                : (categoryScores.usdScore +
                                                categoryScores.bmScore +
                                                categoryScores.qcScore) /
                                            100 >=
                                        0.5
                                    ? Colors.yellow
                                    : Colors
                                        .red, // Substitua pela lógica para obter a cor desejada
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 16.0),
                    FutureBuilder<int>(
                      future: obterValorSprint(widget.projectId),
                      builder:
                          (BuildContext context, AsyncSnapshot<int> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text(
                            'Loading...',
                            style: TextStyle(fontSize: 18.0),
                          );
                        } else if (snapshot.hasError) {
                          return Text(
                            'Error',
                            style: TextStyle(fontSize: 18.0),
                          );
                        } else {
                          return Center(
                            child: Text(
                              'Current Sprint:\nSprint ${snapshot.data}',
                              style: TextStyle(fontSize: 18.0),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (_isExpandedTop)
              Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.0),
                    Text(
                      'Members:',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 8.0),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(members[index]['name']!),
                            subtitle: Text(members[index]['role']!),
                          ),
                        );
                      },
                    ),
                    LinearCharts(id: widget.projectId),
                  ],
                ),
              ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpandedUserStory = !_isExpandedUserStory;
                });
              },
              child: Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: categoryScores.usdScore / 25 >= 0.7
                              ? Colors.green
                              : categoryScores.usdScore / 25 >= 0.5
                                  ? Colors.yellow
                                  : Colors.red,
                          radius: 10.0,
                        ),
                        SizedBox(
                            width:
                                8.0), // Espaçamento entre o círculo e o texto
                        Text(
                          'User Story Definition',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                    Icon(
                      _isExpandedQualityControl
                          ? Icons.expand_less
                          : Icons.expand_more,
                      size: 24.0,
                    ),
                  ],
                ),
              ),
            ),
            /*
            /////////////////////////////////////////////////////////////////////////// 
            Aqui começa a aba User Story Definition expandida
            /////////////////////////////////////////////////////////////////////////// 
            */
            if (_isExpandedUserStory)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: buildProgressTabIndicator(
                  categoryScores.usdScore.toDouble(),
                  25,
                  'User Story Definition',
                ),
              ),
            if (_isExpandedUserStory)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  children: [
                    buildProgressTabText(
                      'User Story Size',
                      'Size of Original Time Estimate (OTE) of estimated issues',
                    ),
                    generateContainer(
                      'OTE > 3 days',
                      'No penalty',
                      '0%(No penalty)',
                      '0%',
                    ),
                    generateContainer(
                      'OTE > 2 days & >= 3 days',
                      'No penalty',
                      '<=10%(No penalty)',
                      '5%',
                    ),
                    generateContainer(
                      'OTE <= 2 days',
                      'No penalty',
                      '>=90%(No penalty)',
                      '95%',
                    ),
                  ],
                ),
              ),
            if (_isExpandedUserStory)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildProgressTabText(
                      'Sample User story 1',
                      'key-001',
                    ),
                    generateContainer(
                      'Acceptance Criteria ',
                      'penalty',
                      'unfilled',
                    ),
                    generateContainer(
                      'Definiton of Ready',
                      'No penalty',
                      'filled',
                    ),
                  ],
                ),
              ),
            if (_isExpandedUserStory)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildProgressTabText(
                      'Sample User story 2',
                      'key-002',
                    ),
                    generateContainer(
                      'Acceptance Criteria ',
                      'penalty',
                      'unfilled',
                    ),
                    generateContainer(
                      'Definiton of Ready',
                      'No penalty',
                      'filled',
                    ),
                  ],
                ),
              ),
            if (_isExpandedUserStory)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildProgressTabText(
                      'Sample User story 3',
                      'key-003',
                    ),
                    generateContainer(
                      'Acceptance Criteria ',
                      'penalty',
                      'unfilled',
                    ),
                    generateContainer(
                      'Definiton of Ready',
                      'No penalty',
                      'filled',
                    ),
                  ],
                ),
              ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpandedBoardManagement = !_isExpandedBoardManagement;
                });
              },
              child: Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: categoryScores.bmScore / 25 >= 0.7
                              ? Colors.green
                              : categoryScores.bmScore / 25 >= 0.5
                                  ? Colors.yellow
                                  : Colors.red,
                          radius: 10.0,
                        ),
                        SizedBox(
                            width:
                                8.0), // Espaçamento entre o círculo e o texto
                        Text(
                          'Board Management',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                    Icon(
                      _isExpandedQualityControl
                          ? Icons.expand_less
                          : Icons.expand_more,
                      size: 24.0,
                    ),
                  ],
                ),
              ),
            ),
            /*
            /////////////////////////////////////////////////////////////////////////// 
            Aqui começa a aba Board Management expandida
            /////////////////////////////////////////////////////////////////////////// 
            */
            if (_isExpandedBoardManagement)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: buildProgressTabIndicator(
                  categoryScores.bmScore.toDouble(),
                  25,
                  'Board Management',
                ),
              ),
            if (_isExpandedBoardManagement)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildProgressTabText(
                      'Sprint Goal Definition',
                      'Sprint goal definition field is filled',
                    ),
                    generateContainer(
                      'Sprint Goal Definition',
                      'No penalty',
                      'Filled',
                    ),
                  ],
                ),
              ),
            if (_isExpandedBoardManagement)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  children: [
                    buildProgressTabText(
                      'Backlog prioritization',
                      'Backlog is prioritized with “Must haves”/highest priority, “Should”/high priority and “Could”/Medium priority items.',
                    ),
                    generateContainer(
                      'Prioritizated',
                      'No penalty',
                      'No penalty',
                    ),
                    generateContainer(
                      'Medium != 100%',
                      'No penalty',
                      'No penalty',
                      '80%',
                    ),
                    generateContainer(
                      'High <= 80%',
                      'No penalty',
                      'No penalty',
                      '10%',
                    ),
                  ],
                ),
              ),
            if (_isExpandedBoardManagement)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  children: [
                    buildProgressTabText(
                      'Defects',
                      'Defects classification, prioritization and estimation (estimation applies only to Major defects)',
                    ),
                    generateContainer(
                      'Classified',
                      'penalty',
                      'Full penalty',
                      'Not',
                    ),
                    generateContainer(
                      'Prioritizated',
                      'penalty',
                      'Full penalty',
                      'Not',
                    ),
                    generateContainer(
                      'Estimated',
                      'penalty',
                      'Full penalty',
                      'Not',
                    ),
                  ],
                ),
              ),
            if (_isExpandedBoardManagement)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  children: [
                    buildProgressTabText(
                      'Front End + Design Issues',
                      'Exists issues from category Front End and/or Design',
                    ),
                    generateContainer(
                      'Front End',
                      'No penalty',
                      'Exists',
                      '10',
                    ),
                    generateContainer(
                      'Design',
                      'No penalty',
                      'Exists',
                      '5',
                    ),
                  ],
                ),
              ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpandedQualityControl = !_isExpandedQualityControl;
                });
              },
              child: Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: categoryScores.qcScore / 50 >= 0.7
                              ? Colors.green
                              : categoryScores.qcScore / 50 >= 0.5
                                  ? Colors.yellow
                                  : Colors.red,
                          radius: 10.0,
                        ),
                        SizedBox(
                            width:
                                8.0), // Espaçamento entre o círculo e o texto
                        Text(
                          'Quality & Control',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                    Icon(
                      _isExpandedQualityControl
                          ? Icons.expand_less
                          : Icons.expand_more,
                      size: 24.0,
                    ),
                  ],
                ),
              ),
            ),
            /*
            /////////////////////////////////////////////////////////////////////////// 
            Aqui começa a aba Quality & Control expandida
            /////////////////////////////////////////////////////////////////////////// 
            */
            if (_isExpandedQualityControl)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: buildProgressTabIndicator(
                  categoryScores.qcScore.toDouble(),
                  50,
                  'Quality & Control',
                ),
              ),
            if (_isExpandedQualityControl)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildProgressTabText(
                      'Sprint Definition',
                      'Accuracy = # of US on “UAT ready” status/ # of US',
                    ),
                    buildProgressTabIndicator(
                      95,
                      100,
                      'Score',
                      optionalParam1: 0.499,
                      optionalParam2: 0.85,
                    ),
                    Center(
                      child: Text(
                        'Excellent(No Penalty)',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              ),
            if (_isExpandedQualityControl)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildProgressTabText(
                      'Issue estimation',
                      'Accuracy = # of estimated issues / # of total issues',
                    ),
                    buildProgressTabIndicator(
                      90,
                      100,
                      'Score',
                      optionalParam1: 0.499,
                      optionalParam2: 0.85,
                    ),
                    Center(
                      child: Text(
                        'Good(5% Penalty)',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              ),
            if (_isExpandedQualityControl)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildProgressTabText(
                      'Project execution',
                      'Accuracy = 100% - |∑total time / ∑estimated| (precise description pending)',
                    ),
                    buildProgressTabIndicator(
                      70,
                      100,
                      'Score',
                      optionalParam1: 0.499,
                      optionalParam2: 0.85,
                    ),
                    Center(
                      child: Text(
                        'To improve(5% Penalty)',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              ),
            if (_isExpandedQualityControl)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildProgressTabText(
                      '# of Bugs in quality',
                      '# of Bugs / # of User Stories',
                    ),
                    Text(
                      'If coverage is <50%, then it’s considered insufficient and full penalty is applied.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        child: Center(
                          child: buildValueRectangle("Test Coverage: ",
                              ds.qualityControlScore.numBugs.coverage, "%"),
                        ),
                      ),
                    ),
                    Center(
                        child: Text(
                      'Score',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    )),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        child: Center(
                          child: ds.qualityControlScore.numBugs.coverage > 0.5
                              ? buildValueRectangle(
                                  "<=", 0.5, " Bugs / User Story")
                              : buildValueRectangle("Full Penalty", null, null),
                        ),
                      ),
                    ),
                    Center(
                        child: Text(
                      'Excellent(No penalty)',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    )),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

/*
/////////////////////////////////////////////////////////////////////////// 
Aqui começam as funções
/////////////////////////////////////////////////////////////////////////// 
*/
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

  Future<void> fetchDetailedScore() async {
    try {
      detailedScore = parseDetailedScore(widget.projectId);
      print(await parseDetailedScore(widget.projectId));
      DetailedScore score = await detailedScore;

      ds = score;
      // Fazer a manipulação do score
      print(ds.userStoryDefinitionScore.USS['OTE1']);

      print(ds.userStoryDefinitionScore.USS);
      print(ds.boardManagementScore.SGD);
      print(score.qualityControlScore.sprintDefinition);
      print(ds);
      categoryScores = generateScores(ds);
      print(categoryScores.usdScore);
      print(categoryScores.bmScore);
      print(categoryScores.qcScore);
    } catch (error) {
      // Tratar erros que possam ocorrer durante o carregamento do score
      print('Erro ao carregar o score: $error');
    }
  }

  Future<void> fetchMembers() async {
    List<Map<String, String>> fetchedMembers =
        await getMembersFromJson(widget.projectId);
    setState(() {
      members = fetchedMembers;
    });
  }

  double calculateProgressValue(int current, int total) {
    return current / total;
  }

  Color getProgressColor(double progressValue,
      {double? threshold1, double? threshold2}) {
    if (threshold1 != null && threshold2 != null) {
      if (progressValue < threshold1) {
        return Colors.red;
      } else if (progressValue < threshold2) {
        return Colors.yellow;
      } else {
        return Colors.green;
      }
    } else {
      if (progressValue < 0.3) {
        return Colors.red;
      } else if (progressValue < 0.7) {
        return Colors.yellow;
      } else {
        return Colors.green;
      }
    }
  }

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

      // Iterar sobre os membros e converter para o formato desejado
      members = membersData.map<Map<String, String>>((member) {
        String name = member['name'];
        String role = member['role'];
        return {'name': name, 'role': role};
      }).toList();
    }

    return members;
  }
}
