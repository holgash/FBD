import 'package:flutter/material.dart';

void main() {
  runApp(ProjectApp());
}

class ProjectApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projects',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProjectPage(),
    );
  }
}

class ProjectPage extends StatefulWidget {
  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  String? selectedFilter =
      'Todos'; // Valor inicial selecionado para DropdownButton
  List<String> filterOptions = ['Todos', 'Concluídos', 'Em progresso'];
  String? selectedRadio; // Valor inicial selecionado para radio button
  List<String> radioOptions = ['Global', 'Agile Delivery', 'AMS', 'M&S'];

  @override
  void initState() {
    super.initState();
    selectedRadio =
        'Global'; // Definir 'Global' como a opção padrão selecionada
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Projects')), // Centralizar o título
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
                  width: MediaQuery.of(context).size.width /
                      2, // Dividir o espaço em duas colunas
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
              itemCount: 10, // Número de resultados fictícios
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text('Projeto $index'),
                  subtitle: Text('Descrição do Projeto $index'),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    // Ação ao tocar em um item da lista
                    print('Projeto $index selecionado');
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
