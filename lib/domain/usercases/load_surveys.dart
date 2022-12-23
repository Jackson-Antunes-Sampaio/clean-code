import 'package:equatable/equatable.dart';

import '../entities/entities.dart';

abstract class LoadSurveys {
  Future<List<SurveyEntity>> load();
}

