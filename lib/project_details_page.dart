import 'package:flutter/material.dart';

class ProjectDetailsPage extends StatefulWidget {
  final String project;

  ProjectDetailsPage(this.project);

  @override
  _ProjectDetailsPageState createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  bool _isExpanded = false;

  List<Map<String, String>> members = [
    {'name': 'John Doe', 'role': 'Developer'},
    {'name': 'Jane Smith', 'role': 'Designer'},
    {'name': 'Mike Johnson', 'role': 'Project Manager'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Projeto'),
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
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
                        Text(
                          'Score: 90',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(width: 16.0),
                        Text(
                          'Sprint Atual: 5',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                    Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      size: 24.0,
                    ),
                  ],
                ),
              ),
            ),
            if (_isExpanded)
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mais informações...',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Membros:',
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
              ),
            Expanded(
              child: TabBarView(
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Detalhes do projeto: ${widget.project}',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Lista de tarefas do projeto: ${widget.project}',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Membros do projeto: ${widget.project}',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
