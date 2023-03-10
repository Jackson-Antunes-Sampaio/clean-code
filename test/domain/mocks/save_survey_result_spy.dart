import 'package:curso_clean_solid/domain/helpers/helpers.dart';
import 'package:curso_clean_solid/domain/entities/entities.dart';
import 'package:curso_clean_solid/domain/usecases/usecases.dart';

import 'package:mocktail/mocktail.dart';

class SaveSurveyResultSpy extends Mock implements SaveSurveyResult {
  When mockSaveCall() => when(() => this.save(answer: any(named: 'answer')));
  void mockSave(SurveyResultEntity data) => mockSaveCall().thenAnswer((_) async => data);
  void mockSaveError(DomainError error) => mockSaveCall().thenThrow(error);
}