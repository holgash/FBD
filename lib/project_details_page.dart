import 'package:flutter/material.dart';

class ProjectDetailsPage extends StatefulWidget {
  final String project;

  ProjectDetailsPage(this.project);

  @override
  _ProjectDetailsPageState createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  bool _isExpandedTop = false;
  bool _isExpandedUserStory = false;
  bool _isExpandedBoardManagement = false;
  bool _isExpandedQualityControl = false;

  // Variáveis para armazenar os valores da aba "User Story Definition"
  int userStoryCurrent = 15;
  int userStoryTotal = 25;

  // Variáveis para armazenar os valores da aba "Board Management"
  int boardManagementCurrent = 20;
  int boardManagementTotal = 25;

  // Variáveis para armazenar os valores da aba "Quality & Control"
  int qualityControlCurrent = 40;
  int qualityControlTotal = 50;
  // Variavel para o # of Bugs in quality
  double coverageValue = 50;

  List<Map<String, String>> members = [
    {'name': 'John Doe', 'role': 'Developer'},
    {'name': 'Jane Smith', 'role': 'Designer'},
    {'name': 'Mike Johnson', 'role': 'Project Manager'},
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Details'),
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
                            "Audit score: ${userStoryCurrent + boardManagementCurrent + qualityControlCurrent}/${userStoryTotal + boardManagementTotal + qualityControlTotal}",
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Text(
                          'Current Sprint: 5',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                    Icon(
                      _isExpandedTop ? Icons.expand_less : Icons.expand_more,
                      size: 24.0,
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
                    Text(
                      'User Story Definition',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Icon(
                      _isExpandedUserStory
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
                  userStoryCurrent.toDouble(),
                  userStoryTotal.toDouble(),
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
                    Text(
                      'Board Management',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Icon(
                      _isExpandedBoardManagement
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
                  boardManagementCurrent.toDouble(),
                  boardManagementTotal.toDouble(),
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
                    Text(
                      'Quality & Control',
                      style: TextStyle(fontSize: 18.0),
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
                  qualityControlCurrent.toDouble(),
                  qualityControlTotal.toDouble(),
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
                          child: buildValueRectangle(
                              "Test Coverage: ", coverageValue, "%"),
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
                          child: coverageValue > 0.5
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
}
