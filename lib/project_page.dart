import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'project_details_page.dart';
import 'dart:convert';

class ProjectPage extends StatefulWidget {
  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  String? selectedFilter = 'Todos';
  List<String> filterOptions = ['Todos', 'Concluídos', 'Em progresso'];
  String? selectedRadio;
  List<String> radioOptions = ['Global', 'Agile Delivery', 'AMS', 'M&S'];
  List<Map<String, dynamic>> projectDetails = [];

  @override
  void initState() {
    super.initState();
    loadProjectDetails();
    selectedRadio = 'Global';
  }

  void loadProjectDetails() async {
    String jsonData = await rootBundle.loadString('assets/projects.json');
    List<dynamic> projects = jsonDecode(jsonData)['projetos'];
    setState(() {
      projectDetails = projects.map((project) {
        return {
          'id': project['id'],
          'project_name': project['project_name'],
          'project_type': project['project_type'],
        };
      }).toList();
    });
  }

  void _onProjectSelected(
      String projectName, String projectType, int projectId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProjectDetailsPage(projectName, projectType, projectId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Projects')),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Filtro:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButton<String>(
              value: selectedFilter,
              onChanged: (String? newValue) {
                setState(() {
                  selectedFilter = newValue;
                });
              },
              items: filterOptions.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Wrap(
              children: radioOptions.map((String option) {
                return Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: RadioListTile<String>(
                    title: Text(option),
                    value: option,
                    groupValue: selectedRadio,
                    onChanged: (String? value) {
                      setState(() {
                        selectedRadio = value;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: projectDetails.length,
              itemBuilder: (BuildContext context, int index) {
                final project = projectDetails[index];
                final id = project['id'];
                final projectName = project['project_name'];
                final projectType = project['project_type'];
                return ListTile(
                  title: Text('$id - $projectName'),
                  subtitle: Text('Project type: $projectType'),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    _onProjectSelected(projectName, projectType, id);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
