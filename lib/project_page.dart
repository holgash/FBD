import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'project_details_page.dart';
import 'dart:convert';

class ProjectPage extends StatefulWidget {
  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  String? selectedFilter;
  List<String> filterOptions = [];
  String? selectedRadio;
  List<String> radioOptions = ['Global', 'Agile Delivery', 'AMS', 'M&S'];
  List<Map<String, dynamic>> projectDetails = [];
  List<Map<String, dynamic>> filteredProjectDetails = [];

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
      filterOptions = [
        'All Projects',
        ...projects.map<String>((project) {
          return project['project_name'] as String;
        }).toList()
      ];
      selectedFilter = filterOptions.isNotEmpty ? filterOptions[0] : null;
      projectDetails = projects.map((project) {
        return {
          'id': project['id'],
          'project_name': project['project_name'],
          'project_type': project['project_type'],
        };
      }).toList();
      filteredProjectDetails = filterProjects();
    });
  }

  List<Map<String, dynamic>> filterProjects() {
    if (selectedFilter == 'All Projects' && selectedRadio == 'Global') {
      return projectDetails;
    } else if (selectedFilter == 'All Projects') {
      return projectDetails.where((project) {
        return project['project_type'] == selectedRadio;
      }).toList();
    } else if (selectedRadio == 'Global') {
      return projectDetails.where((project) {
        return project['project_name'] == selectedFilter;
      }).toList();
    } else {
      return projectDetails.where((project) {
        return project['project_name'] == selectedFilter &&
            project['project_type'] == selectedRadio;
      }).toList();
    }
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

  void _onRadioSelected(String? value) {
    setState(() {
      selectedRadio = value;

      filteredProjectDetails = filterProjects();
    });
  }

  void _onFilterSelected(String? value) {
    setState(() {
      selectedFilter = value;
      filteredProjectDetails = filterProjects();
    });
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
              'Filter:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButton<String>(
              value: selectedFilter,
              onChanged: _onFilterSelected,
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
                    onChanged: _onRadioSelected,
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProjectDetails.length,
              itemBuilder: (BuildContext context, int index) {
                final project = filteredProjectDetails[index];
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
