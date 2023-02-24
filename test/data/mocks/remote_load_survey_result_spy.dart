import 'package:curso_clean_solid/data/usecases/usecases.dart';
import 'package:curso_clean_solid/domain/entities/entities.dart';
import 'package:curso_clean_solid/domain/helpers/helpers.dart';

import 'package:mocktail/mocktail.dart';

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {
  When mockLoadCall() => when(() => this.loadBySurvey(surveyId: any(named: 'surveyId')));
  void mockLoad(SurveyResultEntity surveyResult) => this.mockLoadCall().thenAnswer((_) async => surveyResult);
  void mockLoadError(DomainError error) => this.mockLoadCall().thenThrow(error);
}