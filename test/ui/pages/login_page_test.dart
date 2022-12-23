
import 'dart:async';

import 'package:curso_clean_solid/ui/helpers/errors/errors.dart';
import 'package:curso_clean_solid/ui/pages/pages.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter{}

void main() {

  late LoginPresenter presenter;
  late StreamController<UIError?>? emailErrorController;
  late StreamController<UIError?>? passwordErrorController;
  late StreamController<bool>? isFormValidController;
  late StreamController<bool>? isLoadingController;
  late StreamController<UIError>? mainErrorController;
  late StreamController<String>? navigateToController;

  void initStream(){
    emailErrorController = StreamController<UIError>();
    passwordErrorController = StreamController<UIError>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();
    mainErrorController = StreamController<UIError>();
    navigateToController = StreamController<String>();
  }

  void mockStreams(){
    when(presenter.emailErrorStream).thenAnswer((_) => emailErrorController!.stream);
    when(presenter.passwordErrorStream).thenAnswer((_) => passwordErrorController!.stream);
    when(presenter.isFormValidStream).thenAnswer((_) => isFormValidController!.stream);
    when(presenter.isLoadingStream).thenAnswer((_) => isLoadingController!.stream);
    when(presenter.mainErrorStream).thenAnswer((_) => mainErrorController!.stream);
    when(presenter.navigateToStream).thenAnswer((_) => navigateToController!.stream);
  }

  void closeStreams(){
    emailErrorController?.close();
    passwordErrorController?.close();
    isFormValidController?.close();
    isLoadingController?.close();
    mainErrorController?.close();
    navigateToController?.close();
  }

  Future<void> loadPage(WidgetTester tester)async{

    presenter = LoginPresenterSpy();
    initStream();
    mockStreams();


    final loginPage = GetMaterialApp(
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: ()=> LoginPage(presenter: presenter)),
        GetPage(name: '/any_route', page: ()=> const Scaffold(body: Text("Fake page")))
      ],
    );
    await tester.pumpWidget(loginPage);
  }

  tearDown((){
    closeStreams();

  });

  testWidgets("Should load with correct initial state",
      (WidgetTester tester) async {

       await  loadPage(tester);
    final emailTextChildren = find.descendant(
      of: find.bySemanticsLabel('Email'),
      matching: find.byType(Text),
    );

    expect(
      emailTextChildren,
      findsOneWidget,
      reason:
          'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the hint text',
    );

    final passwordTextChildren = find.descendant(
      of: find.bySemanticsLabel('Senha'),
      matching: find.byType(Text),
    );

    expect(
      passwordTextChildren,
      findsOneWidget,
      reason:
          'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the hint text',
    );

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(button.onPressed, null);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });


  testWidgets("Should call validate with correct values", (WidgetTester tester) async {
    await  loadPage(tester);

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    verify(presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(presenter.validatePassword(password));

  });

  testWidgets("Should present error if email is invalid", (WidgetTester tester) async {
    await  loadPage(tester);

    emailErrorController?.add(UIError.invalidField);
    await tester.pump();
  
    expect(find.text('Campo inválido'), findsOneWidget);
    
  });

  testWidgets("Should present error if email is empty", (WidgetTester tester) async {
    await  loadPage(tester);

    emailErrorController?.add(UIError.requiredField);
    await tester.pump();

    expect(find.text('Campo obrigatório'), findsOneWidget);

  });

  testWidgets("Should present no error if email is invalid", (WidgetTester tester) async {
    await  loadPage(tester);

    emailErrorController?.add(null);
    await tester.pump();

    final emailTextChildren = find.descendant(
      of: find.bySemanticsLabel('Email'),
      matching: find.byType(Text),
    );

    expect(
      emailTextChildren,
      findsOneWidget,
    );

  });

  testWidgets("Should present error if password is empty", (WidgetTester tester) async {
    await  loadPage(tester);

    passwordErrorController?.add(UIError.requiredField);
    await tester.pump();

    expect(find.text('Campo obrigatório'), findsOneWidget);

  });

  testWidgets("Should present no error if password is invalid", (WidgetTester tester) async {
    await  loadPage(tester);

    passwordErrorController?.add(null);
    await tester.pump();

    final passwordTextChildren = find.descendant(
      of: find.bySemanticsLabel('Senha'),
      matching: find.byType(Text),
    );

    expect(
      passwordTextChildren,
      findsOneWidget,
    );

  });

  testWidgets("Should enable form button if form is valid", (WidgetTester tester) async {
    await  loadPage(tester);

    isFormValidController?.add(true);
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(button.onPressed, isNotNull);

  });

  testWidgets("Should disable form button if form is invalid", (WidgetTester tester) async {
    await  loadPage(tester);

    isFormValidController?.add(false);
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(button.onPressed, null);

  });

  testWidgets("Should call authentication on form submit ", (WidgetTester tester) async {
    await  loadPage(tester);
    
    isFormValidController?.add(true);
    await tester.pump();
    final button = find.byType(ElevatedButton);
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(presenter.auth()).called(1);

  });

  testWidgets("Should present loading", (WidgetTester tester) async {
    await  loadPage(tester);

    isLoadingController?.add(true);
    await tester.pump();


    expect(find.byType(CircularProgressIndicator), findsOneWidget);

  });

  testWidgets("Should hide loading", (WidgetTester tester) async {
    await  loadPage(tester);

    isLoadingController?.add(true);
    await tester.pump();

    isLoadingController?.add(false);
    await tester.pump();


    expect(find.byType(CircularProgressIndicator), findsNothing);

  });

  testWidgets("Should present error message if authentication fails ", (WidgetTester tester) async {
    await loadPage(tester);

    mainErrorController?.add(UIError.invalidCredentials);
    await tester.pump();

    expect(find.text('Credenciais inválidas.'), findsOneWidget);
  });

  testWidgets("Should present error message if authentication throws ", (WidgetTester tester) async {
    await loadPage(tester);

    mainErrorController?.add(UIError.unexpected);
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'), findsOneWidget);
  });

  testWidgets("Should change page ", (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController?.add('/any_route');
    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/any_route');
    expect(find.text('Fake page'), findsOneWidget);

  });

  testWidgets("Should call gotoSignUp on link click ", (WidgetTester tester) async {
    await  loadPage(tester);


    final button = find.text('Criar conta');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(presenter.goToSignUp()).called(1);

  });



}