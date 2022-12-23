import 'dart:async';

import 'package:curso_clean_solid/ui/helpers/errors/ui_error.dart';
import 'package:curso_clean_solid/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/helpers.dart';
import '../mocks/viewmodel_factory.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter{
  final surveysController = StreamController<List<SurveyViewModel>>();
  final isSessionExpiredController = StreamController<bool>();
  final isLoadingController = StreamController<bool>();
  final navigateToController = StreamController<String?>();

  SurveysPresenterSpy() {
    when(() => loadData()).thenAnswer((_) async => _);
    when(() => surveysStream).thenAnswer((_) => surveysController.stream);
    when(() => isSessionExpiredStream).thenAnswer((_) => isSessionExpiredController.stream);
    when(() => isLoadingStream).thenAnswer((_) => isLoadingController.stream);
    when(() => navigateToStream).thenAnswer((_) => navigateToController.stream);
  }

  void emitSurveys(List<SurveyViewModel> data) => surveysController.add(data);
  void emitSurveysError(String error) => surveysController.addError(error);
  void emitLoading([bool show = true]) => isLoadingController.add(show);
  void emitSessionExpired([bool show = true]) => isSessionExpiredController.add(show);
  void emitNavigateTo(String route) => navigateToController.add(route);

  void dispose() {
    surveysController.close();
    isSessionExpiredController.close();
    isLoadingController.close();
    navigateToController.close();
  }
}

void main(){

  late SurveysPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveysPresenterSpy();
    await tester.pumpWidget(makePage(path: '/surveys', page: () => SurveysPage(presenter)));
  }

  tearDown(() {
    presenter.dispose();
  });

  testWidgets('Should call LoadSurveys on page load', (WidgetTester tester) async {
    await loadPage(tester);

    verify(() => presenter.loadData()).called(1);
  });

  testWidgets('Should handle loading correctly', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitLoading();
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    presenter.emitLoading(false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);

    presenter.emitLoading();
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should present error if surveysStream fails', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSurveysError(UIError.unexpected.description);
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'), findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget);
    expect(find.text('Question 1'), findsNothing);
  });

  testWidgets('Should present list if surveysStream succeeds', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSurveys(ViewModelFactory.makeSurveyList());
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'), findsNothing);
    expect(find.text('Recarregar'), findsNothing);
    expect(find.text('Question 1'), findsWidgets);
    expect(find.text('Question 2'), findsWidgets);
    expect(find.text('Date 1'), findsWidgets);
    expect(find.text('Date 2'), findsWidgets);
  });

  testWidgets('Should call LoadSurveys on reload button click', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSurveysError(UIError.unexpected.description);
    await tester.pump();
    await tester.tap(find.text('Recarregar'));

    verify(() => presenter.loadData()).called(2);
  });

}