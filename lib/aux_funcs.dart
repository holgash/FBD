import 'detailedScore.dart';

generateScores(DetailedScore ds) {
  categoryScore auxScores = categoryScore();
  auxScores.usdScore = generateUSDScore(ds);
  auxScores.bmScore = generateBMScore(ds);
  auxScores.qcScore = generateQCScore(ds);

  return auxScores;
}

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
