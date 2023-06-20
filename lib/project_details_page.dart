import 'package:flutter/material.dart';
import 'aux_funcs.dart';
import 'detailedScore.dart';
import 'linear_charts.dart';

// ignore: must_be_immutable
class ProjectDetailsPage extends StatefulWidget {
  //variveis de entrada
  final String projectName;
  final String projectType;
  final int projectId;
  Future<DetailedScore>? detailedScore;

  ProjectDetailsPage(this.projectName, this.projectType, this.projectId);

  @override
  // ignore: library_private_types_in_public_api
  _ProjectDetailsPageState createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  //variaveis locais
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
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(
                    color: Colors.black,
                    width: 1.5,
                  ),
                ),
                //aba superior(detalhes do projeto)
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 120.0,
                          child: RichText(
                            text: TextSpan(
                              text: 'Audit score\n',
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                      '${categoryScores.usdScore + categoryScores.bmScore + categoryScores.qcScore}/100',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      //selecionar a cor do texto baseado no audit score atual
                                      color: getProgressColor(
                                          (categoryScores.usdScore +
                                                  categoryScores.bmScore +
                                                  categoryScores.qcScore) /
                                              100)),
                                ),
                              ],
                            ),
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
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.black),
                                children: [
                                  TextSpan(text: 'Current sprint\n'),
                                  TextSpan(
                                    text: 'Sprint ${snapshot.data}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.right,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            //aba superior(detalhes do projeto) expandida
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
                    //gerar lista de membros do projeto
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
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Score by sprint',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    //gerar grafico com o histórico de audit scores
                    LinearCharts(id: widget.projectId),
                  ],
                ),
              ),
            //segunda aba(User Story Definition(USD))
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
                          backgroundColor:
                              //gerar cor do circulo baseado na pontuação atual dessa categoria
                              getProgressColor(categoryScores.usdScore / 25),
                          radius: 8.0,
                        ),
                        SizedBox(width: 8.0),
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
                    /*
                    Toda a logica por trás das pontuações são definidas a partir das regras de negócio que não estão divulgadas no código. 
                    */
                    //User Story Size
                    buildProgressTabText(
                      'User Story Size',
                      'Size of Original Time Estimate (OTE) of estimated issues',
                    ),
                    generateContainer(
                      'OTE > 3 days',
                      ds.userStoryDefinitionScore.USS['OTE1'] == 0
                          ? 'No penalty'
                          : 'penalty',
                      ds.userStoryDefinitionScore.USS['OTE1'] == 0
                          ? '0%(No penalty)'
                          : '> 0%(Full penalty)',
                      '${ds.userStoryDefinitionScore.USS['OTE1']}%',
                    ),
                    generateContainer(
                      'OTE > 2 days & >= 3 days',
                      ds.userStoryDefinitionScore.USS['OTE2']! <= 10
                          ? 'No penalty'
                          : 'penalty',
                      ds.userStoryDefinitionScore.USS['OTE2']! <= 10
                          ? '<=10%(No penalty)'
                          : '> 10%(Full penalty)',
                      '${ds.userStoryDefinitionScore.USS['OTE2']}%',
                    ),
                    generateContainer(
                      'OTE <= 2 days',
                      ds.userStoryDefinitionScore.USS['OTE3']! >= 90
                          ? 'No penalty'
                          : 'penalty',
                      ds.userStoryDefinitionScore.USS['OTE3']! >= 90
                          ? '>=90%(No penalty)'
                          : '< 90%(Full penalty)',
                      '${ds.userStoryDefinitionScore.USS['OTE3']}%',
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
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Sample User stories (top 3 by size)',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Sample User story 1
                          buildProgressTabText(
                            'Sample User story 1',
                            'key-001',
                          ),
                          generateContainer(
                            'Acceptance Criteria',
                            ds.userStoryDefinitionScore.SUS1
                                        .acceptanceCriteria ==
                                    true
                                ? 'No penalty'
                                : 'penalty',
                            ds.userStoryDefinitionScore.SUS1
                                        .acceptanceCriteria ==
                                    true
                                ? 'filled'
                                : 'unfilled',
                          ),
                          generateContainer(
                            'Definition of Ready',
                            ds.userStoryDefinitionScore.SUS1
                                        .definitionOfReady ==
                                    true
                                ? 'No penalty'
                                : 'penalty',
                            ds.userStoryDefinitionScore.SUS1
                                        .definitionOfReady ==
                                    true
                                ? 'filled'
                                : 'unfilled',
                          ),
                        ],
                      ),
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
                    //Sample User story 2
                    buildProgressTabText(
                      'Sample User story 2',
                      'key-002',
                    ),
                    generateContainer(
                      'Acceptance Criteria',
                      ds.userStoryDefinitionScore.SUS2.acceptanceCriteria ==
                              true
                          ? 'No penalty'
                          : 'penalty',
                      ds.userStoryDefinitionScore.SUS2.acceptanceCriteria ==
                              true
                          ? 'filled'
                          : 'unfilled',
                    ),
                    generateContainer(
                      'Definition of Ready',
                      ds.userStoryDefinitionScore.SUS2.definitionOfReady == true
                          ? 'No penalty'
                          : 'penalty',
                      ds.userStoryDefinitionScore.SUS2.definitionOfReady == true
                          ? 'filled'
                          : 'unfilled',
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
                    //Sample User story 3
                    buildProgressTabText(
                      'Sample User story 3',
                      'key-003',
                    ),
                    generateContainer(
                      'Acceptance Criteria',
                      ds.userStoryDefinitionScore.SUS3.acceptanceCriteria ==
                              true
                          ? 'No penalty'
                          : 'penalty',
                      ds.userStoryDefinitionScore.SUS3.acceptanceCriteria ==
                              true
                          ? 'filled'
                          : 'unfilled',
                    ),
                    generateContainer(
                      'Definition of Ready',
                      ds.userStoryDefinitionScore.SUS3.definitionOfReady == true
                          ? 'No penalty'
                          : 'penalty',
                      ds.userStoryDefinitionScore.SUS3.definitionOfReady == true
                          ? 'filled'
                          : 'unfilled',
                    ),
                  ],
                ),
              ),
            //terceira aba(Board Management(BM))
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
                          backgroundColor:
                              //gerar cor baseado no valor atual da categoria
                              getProgressColor(categoryScores.bmScore / 25),
                          radius: 8.0,
                        ),
                        SizedBox(width: 8.0),
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
                    //Sprint goal definition
                    buildProgressTabText(
                      'Sprint Goal Definition',
                      'Sprint goal definition field is filled',
                    ),
                    generateContainer(
                      'Sprint Goal Definition',
                      ds.boardManagementScore.SGD == true
                          ? 'No penalty'
                          : 'penalty',
                      ds.boardManagementScore.SGD == true
                          ? 'Filled'
                          : 'Unfilled',
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
                    //Backlog prioritization
                    buildProgressTabText(
                      'Backlog prioritization',
                      'Backlog is prioritized with “Must haves”/highest priority, “Should”/high priority and “Could”/Medium priority items.',
                    ),
                    generateContainer(
                      'Prioritizated',
                      ds.boardManagementScore.bpScore.prioritized == true
                          ? 'No penalty'
                          : 'penalty',
                      ds.boardManagementScore.bpScore.prioritized == true
                          ? 'No penalty'
                          : 'Penalty',
                    ),
                    generateContainer(
                      'Medium != 100%',
                      ds.boardManagementScore.bpScore.medium != 100
                          ? 'No penalty'
                          : 'penalty',
                      ds.boardManagementScore.bpScore.medium != 100
                          ? 'No penalty'
                          : 'Penalty',
                      '${ds.boardManagementScore.bpScore.medium}%',
                    ),
                    generateContainer(
                      'High <= 80%',
                      ds.boardManagementScore.bpScore.high <= 80
                          ? 'No penalty'
                          : 'penalty',
                      ds.boardManagementScore.bpScore.high <= 80
                          ? 'No penalty'
                          : 'Penalty',
                      '${ds.boardManagementScore.bpScore.high}%',
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
                    //Defects
                    buildProgressTabText(
                      'Defects',
                      'Defects classification, prioritization and estimation (estimation applies only to Major defects)',
                    ),
                    generateContainer(
                      'Classified',
                      ds.boardManagementScore.defects.classified == true
                          ? 'No penalty'
                          : 'penalty',
                      ds.boardManagementScore.defects.classified == true
                          ? 'No penalty'
                          : 'Full penalty',
                    ),
                    generateContainer(
                      'Prioritizated',
                      ds.boardManagementScore.defects.prioritized == true
                          ? 'No penalty'
                          : 'penalty',
                      ds.boardManagementScore.defects.prioritized == true
                          ? 'No penalty'
                          : 'Full penalty',
                    ),
                    generateContainer(
                      'Estimated',
                      ds.boardManagementScore.defects.estimated == true
                          ? 'No penalty'
                          : 'penalty',
                      ds.boardManagementScore.defects.estimated == true
                          ? 'No penalty'
                          : 'Full penalty',
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
                    //Front End + Design issues
                    buildProgressTabText(
                      'Front End + Design Issues',
                      'Exists issues from category Front End and/or Design',
                    ),
                    generateContainer(
                      'Front End',
                      ds.boardManagementScore.feDesign.FE > 0
                          ? 'No penalty'
                          : 'penalty',
                      ds.boardManagementScore.feDesign.FE > 0
                          ? 'Exists'
                          : 'Doesn\'t exists',
                      ds.boardManagementScore.feDesign.FE.toString(),
                    ),
                    generateContainer(
                      'Design',
                      ds.boardManagementScore.feDesign.design > 0
                          ? 'No penalty'
                          : 'penalty',
                      ds.boardManagementScore.feDesign.design > 0
                          ? 'Exists'
                          : 'Doesn\'t exists',
                      ds.boardManagementScore.feDesign.design.toString(),
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
                          backgroundColor:
                              //gerar cor baseado no valor atual da categoria
                              getProgressColor(categoryScores.qcScore / 50),
                          radius: 8.0,
                        ),
                        SizedBox(width: 8.0),
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
                    //Sprint definition
                    buildProgressTabText(
                      'Sprint Definition',
                      'Accuracy = # of US on “UAT ready” status/ # of US',
                    ),
                    buildProgressTabIndicator(
                      ds.qualityControlScore.sprintDefinition.toDouble(),
                      100,
                      'Score',
                      optionalParam1: 0.499,
                      optionalParam2: 0.85,
                    ),
                    Center(
                      child: Text(
                        ds.qualityControlScore.sprintDefinition >= 90
                            ? 'Excellent(No Penalty)'
                            : ds.qualityControlScore.sprintDefinition >= 85
                                ? 'Good(5% Penalty)'
                                : ds.qualityControlScore.sprintDefinition >= 50
                                    ? 'To improve (10% Penalty)'
                                    : 'Not met(Full penalty)',
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
                    //Issues estimation
                    buildProgressTabText(
                      'Issue estimation',
                      'Accuracy = # of estimated issues / # of total issues',
                    ),
                    buildProgressTabIndicator(
                      ds.qualityControlScore.issueEstimation.toDouble(),
                      100,
                      'Score',
                      optionalParam1: 0.7499,
                      optionalParam2: 0.85,
                    ),
                    Center(
                      child: Text(
                        ds.qualityControlScore.issueEstimation == 100
                            ? 'Excellent(No Penalty)'
                            : ds.qualityControlScore.issueEstimation >= 85
                                ? 'Good(5% Penalty)'
                                : ds.qualityControlScore.issueEstimation >= 75
                                    ? 'To improve (10% Penalty)'
                                    : 'Not met(Full penalty)',
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
                    //Project execution
                    buildProgressTabText(
                      'Project execution',
                      'Accuracy = 100% - |∑total time / ∑estimated| (precise description pending)',
                    ),
                    buildProgressTabIndicator(
                      ds.qualityControlScore.projectExecution.toDouble(),
                      100,
                      'Score',
                      optionalParam1: 0.699,
                      optionalParam2: 0.85,
                    ),
                    Center(
                      child: Text(
                        ds.qualityControlScore.projectExecution >= 95
                            ? 'Excellent(No Penalty)'
                            : ds.qualityControlScore.projectExecution >= 85
                                ? 'Good(2% Penalty)'
                                : ds.qualityControlScore.projectExecution >= 70
                                    ? 'To improve (5% Penalty)'
                                    : 'Not met(Full penalty)',
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
                    //Number of bugs in quality
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
                              ? ds.qualityControlScore.numBugs.numBugs /
                                          ds.qualityControlScore.numBugs
                                              .numStories <=
                                      0.5
                                  ? buildValueRectangle(
                                      "<=", 0.5, " Bugs / User Story")
                                  : ds.qualityControlScore.numBugs.numBugs /
                                              ds.qualityControlScore.numBugs
                                                  .numStories <=
                                          2
                                      ? buildValueRectangle(
                                          "<=", 2, " Bugs / User Story")
                                      : ds.qualityControlScore.numBugs.numBugs /
                                                  ds.qualityControlScore.numBugs
                                                      .numStories <=
                                              3
                                          ? buildValueRectangle(
                                              "<=", 3, " Bugs / User Story")
                                          : buildValueRectangle(
                                              "Full Penalty", null, null)
                              : buildValueRectangle("Full Penalty", null, null),
                        ),
                      ),
                    ),
                    Center(
                        child: Text(
                      ds.qualityControlScore.numBugs.coverage > 0.5
                          ? ds.qualityControlScore.numBugs.numBugs /
                                      ds.qualityControlScore.numBugs
                                          .numStories <=
                                  0.5
                              ? 'Excellent(No penalty)'
                              : ds.qualityControlScore.numBugs.numBugs /
                                          ds.qualityControlScore.numBugs
                                              .numStories <=
                                      2
                                  ? 'Good(2% penalty)'
                                  : ds.qualityControlScore.numBugs.numBugs /
                                              ds.qualityControlScore.numBugs
                                                  .numStories <=
                                          3
                                      ? 'To improve(5% penalty)'
                                      : 'Not met (Full penalty)'
                          : 'Not met (Full penalty)',
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
Funções locais
/////////////////////////////////////////////////////////////////////////// 
*/
  Future<void> fetchDetailedScore() async {
    try {
      detailedScore = parseDetailedScore(widget.projectId);
      DetailedScore score = await detailedScore;
      ds = score;
      categoryScores = generateScores(ds);
    } catch (error) {
      //Se der erro no carregamento do score
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
}
