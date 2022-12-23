import 'package:curso_clean_solid/domain/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:curso_clean_solid/domain/usercases/usercases.dart';
import 'package:curso_clean_solid/data/usecases/usecases.dart';
import 'package:curso_clean_solid/data/http/http.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteAddAccount? sut;
  late HttpClientSpy? httpClient;
  late String? url;
  late AddAccountParams? params;

  Map mockValidData ()=>{'accessToken': faker.guid.guid(), "name": faker.person.name()};


  When mockRequest() => when(
    httpClient?.request(
      url: (anyNamed("url") ?? "url"),
      method: (anyNamed('method') ?? "method"),
      body: anyNamed("body"),
    ),
  );

  void mockHttpData(Map data) {
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError httpError){
    mockRequest().thenThrow(httpError);
  }


  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAddAccount(httpClient: httpClient!, url: url!);
    params = AddAccountParams(
        email: faker.internet.email(),
        name: faker.person.name(),
        password: faker.internet.password(),
      passwordConfirmation: faker.internet.password(),
    );
    mockHttpData(mockValidData());
  });

  test('should call HttpClient with correct values', () async {

    await sut?.add(params: params!);

    verify(
      httpClient?.request(
        url: url!,
        method: 'post',
        body: {
          "email": params?.email,
          "password": params?.password,
          'name' : params?.name,
          'passwordConfirmation' : params?.passwordConfirmation
        },
      ),
    );
  });

  test('should throw UnexpectedError if HttpClient returns 400', () async {
    mockHttpError(HttpError.badRequest);

    final future = sut?.add(params: params!);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError if HttpClient returns 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut?.add(params: params!);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError if HttpClient returns 500', () async {
    mockHttpError(HttpError.serverError);

    final future = sut?.add(params: params!);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw InvalidCredentialsError if HttpClient returns 403',
          () async {
        mockHttpError(HttpError.forbidden);

        final future = sut?.add(params: params!);

        expect(future, throwsA(DomainError.emailInUser));
      });

  test('should return an Account if HttpClient returns 200', () async {
    final validData = mockValidData();
    mockHttpData(validData);

    final account = await sut?.add(params: params!);

    expect(account?.token, validData['accesToken']);
  });

  test(
      'should throw UnexpectedError if HttpClient returns 200 with invalid data',
          () async {
        mockHttpData({'invalidKey': 'invalid_value',});

        final future = sut?.add(params: params!);

        expect(future, throwsA(DomainError.unexpected));
      });
}
