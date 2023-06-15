import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';

class DetailedScore {
  UserStoryDefinitionScore userStoryDefinitionScore;
  BoardManagementScore boardManagementScore;
  QualityControlScore qualityControlScore;

  DetailedScore({
    required this.userStoryDefinitionScore,
    required this.boardManagementScore,
    required this.qualityControlScore,
  });

  factory DetailedScore.fromJson(Map<String, dynamic> json) {
    return DetailedScore(
      userStoryDefinitionScore: UserStoryDefinitionScore.fromJson(
          json['user_story_definition_score']),
      boardManagementScore:
          BoardManagementScore.fromJson(json['board_management_score']),
      qualityControlScore:
          QualityControlScore.fromJson(json['quality_control_score']),
    );
  }
}

class UserStoryDefinitionScore {
  Map<String, int> USS;
  SUScore SUS1;
  SUScore SUS2;
  SUScore SUS3;

  UserStoryDefinitionScore({
    required this.USS,
    required this.SUS1,
    required this.SUS2,
    required this.SUS3,
  });

  factory UserStoryDefinitionScore.fromJson(Map<String, dynamic> json) {
    Map<String, int> uss = {};
    json['USS'].forEach((key, value) {
      uss[key] = value;
    });

    return UserStoryDefinitionScore(
      USS: uss,
      SUS1: SUScore.fromJson(json['SUS1']),
      SUS2: SUScore.fromJson(json['SUS2']),
      SUS3: SUScore.fromJson(json['SUS3']),
    );
  }
}

class SUScore {
  bool acceptanceCriteria;
  bool definitionOfReady;

  SUScore({
    required this.acceptanceCriteria,
    required this.definitionOfReady,
  });

  factory SUScore.fromJson(Map<String, dynamic> json) {
    return SUScore(
      acceptanceCriteria: json['Acceptance Criteria'],
      definitionOfReady: json['Definition of Ready'],
    );
  }
}

class OTE {
  bool acceptanceCriteria;
  bool definitionOfReady;

  OTE({
    required this.acceptanceCriteria,
    required this.definitionOfReady,
  });

  factory OTE.fromJson(Map<String, dynamic> json) {
    return OTE(
      acceptanceCriteria: json['Acceptance Criteria'],
      definitionOfReady: json['Definition of Ready'],
    );
  }
}

class BoardManagementScore {
  bool SGD;
  BPScore bpScore;
  Defects defects;
  FEDesign feDesign;

  BoardManagementScore({
    required this.SGD,
    required this.bpScore,
    required this.defects,
    required this.feDesign,
  });

  factory BoardManagementScore.fromJson(Map<String, dynamic> json) {
    return BoardManagementScore(
      SGD: json['SGD'],
      bpScore: BPScore.fromJson(json['BP']),
      defects: Defects.fromJson(json['Defects']),
      feDesign: FEDesign.fromJson(json['FE+DI']),
    );
  }
}

class BPScore {
  bool prioritized;
  int medium;
  int high;

  BPScore({
    required this.prioritized,
    required this.medium,
    required this.high,
  });

  factory BPScore.fromJson(Map<String, dynamic> json) {
    return BPScore(
      prioritized: json['Prioritized'],
      medium: json['Medium'],
      high: json['High'],
    );
  }
}

class Defects {
  bool classified;
  bool prioritized;
  bool estimated;

  Defects({
    required this.classified,
    required this.prioritized,
    required this.estimated,
  });

  factory Defects.fromJson(Map<String, dynamic> json) {
    return Defects(
      classified: json['Classified'],
      prioritized: json['Prioritized'],
      estimated: json['Estimated'],
    );
  }
}

class FEDesign {
  int FE;
  int design;

  FEDesign({
    required this.FE,
    required this.design,
  });

  factory FEDesign.fromJson(Map<String, dynamic> json) {
    return FEDesign(
      FE: json['FE'],
      design: json['Design'],
    );
  }
}

class QualityControlScore {
  int sprintDefinition;
  int issueEstimation;
  int projectExecution;
  NumBugs numBugs;

  QualityControlScore({
    required this.sprintDefinition,
    required this.issueEstimation,
    required this.projectExecution,
    required this.numBugs,
  });

  factory QualityControlScore.fromJson(Map<String, dynamic> json) {
    print(json);
    return QualityControlScore(
      sprintDefinition: json['SprintDefinition'],
      issueEstimation: json['IssueEstimation'],
      projectExecution: json['ProjectExecution'],
      numBugs: NumBugs.fromJson(json['num_bugs']),
    );
  }
}

class NumBugs {
  int numBugs;
  int numStories;
  double coverage;

  NumBugs({
    required this.numBugs,
    required this.numStories,
    required this.coverage,
  });

  factory NumBugs.fromJson(Map<String, dynamic> json) {
    return NumBugs(
      numBugs: json['num_bugs'],
      numStories: json['num_stories'],
      coverage: json['coverage'],
    );
  }
}

class categoryScore {
  int usdScore;
  int bmScore;
  int qcScore;

  categoryScore({
    this.usdScore = 0,
    this.bmScore = 0,
    this.qcScore = 0,
  });
}

Future<DetailedScore> parseDetailedScore(int id) async {
  String jsonString = await rootBundle.loadString('assets/sprint.json');
  final Map<String, dynamic> json = jsonDecode(jsonString);

  Map<String, dynamic>? project = json['projetos']
      .firstWhere((proj) => proj['id'] == id, orElse: () => null);

  if (project != null) {
    return DetailedScore.fromJson(project['detailed_score']);
  }
  throw Exception('Project not found with ID: $id');
}
