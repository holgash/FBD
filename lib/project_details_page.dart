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

  List<Map<String, String>> members = [
    {'name': 'John Doe', 'role': 'Developer'},
    {'name': 'Tuga', 'role': 'Safado'},
    {'name': 'Jane Smith', 'role': 'Designer'},
    {'name': 'Mike Johnson', 'role': 'Project Manager'},
  ];

  double calculateProgressValue(int current, int total) {
    return current / total;
  }

  Color getProgressColor(double progressValue) {
    if (progressValue < 0.3) {
      return Colors.red;
    } else if (progressValue < 0.7) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Details'),
      ),
      body: SingleChildScrollView(
        // Adicionado SingleChildScrollView
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
            if (_isExpandedUserStory)
              buildProgressTab(
                'Score',
                'Score: $userStoryCurrent/$userStoryTotal',
                calculateProgressValue(userStoryCurrent, userStoryTotal),
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
            if (_isExpandedBoardManagement)
              buildProgressTab(
                'Board Management',
                'Score: $boardManagementCurrent/$boardManagementTotal',
                calculateProgressValue(
                    boardManagementCurrent, boardManagementTotal),
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
            if (_isExpandedQualityControl)
              buildProgressTab(
                'Quality & Control',
                'Score: $qualityControlCurrent/$qualityControlTotal',
                calculateProgressValue(
                    qualityControlCurrent, qualityControlTotal),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildProgressTab(
      String title, String progressText, double progressValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18.0),
              ),
              Text(
                progressText,
                style: TextStyle(fontSize: 18.0),
              ),
            ],
          ),
        ),
        LinearProgressIndicator(
          value: progressValue,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            getProgressColor(progressValue),
          ),
        ),
        SizedBox(height: 16.0),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'User Story Size',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 8.0),
              Text(
                'Small',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                'Tasks:',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 8.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text('Task ${index + 1}'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProjectDetailsPage('My Project'),
  ));
}
