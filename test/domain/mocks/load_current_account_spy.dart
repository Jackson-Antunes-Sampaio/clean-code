import 'package:curso_clean_solid/domain/entities/entities.dart';
import 'package:curso_clean_solid/domain/usecases/usecases.dart';

import 'package:mocktail/mocktail.dart';

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {
  When mockLoadCall() => when(() => this.load());
  void mockLoad({ required AccountEntity account }) => this.mockLoadCall().thenAnswer((_) async => account);
  void mockLoadError() => this.mockLoadCall().thenThrow(Exception());
}