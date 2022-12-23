import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:curso_clean_solid/domain/usercases/usercases.dart';
import 'package:curso_clean_solid/domain/helpers/helpers.dart';

import 'package:curso_clean_solid/data/usecases/usecases.dart';
import 'package:curso_clean_solid/data/http/http.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteAuthentication? sut;
  HttpClientSpy? httpClient;
  String? url;
  AuthenticationParams? params;

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
    sut = RemoteAuthentication(httpClient: httpClient!, url: url!);
    params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());
    mockHttpData(mockValidData());
  });

  test('should call HttpClient with correct values', () async {

    await sut?.auth(params: params!);

    verify(
      httpClient?.request(
        url: url!,
        method: 'post',
        body: {"email": params?.email, "password": params?.secret},
      ),
    );
  });

  test('should throw UnexpectedError if HttpClient returns 400', () async {
    mockHttpError(HttpError.badRequest);

    final future = sut?.auth(params: params!);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError if HttpClient returns 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut?.auth(params: params!);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError if HttpClient returns 500', () async {
    mockHttpError(HttpError.serverError);

    final future = sut?.auth(params: params!);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw InvalidCredentialsError if HttpClient returns 401',
      () async {
        mockHttpError(HttpError.unauthorized);

    final future = sut?.auth(params: params!);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('should return an Account if HttpClient returns 200', () async {
    final validData = mockValidData();
    mockHttpData(validData);

    final account = await sut?.auth(params: params!);

    expect(account?.token, validData['accesToken']);
  });

  test(
      'should throw UnexpectedError if HttpClient returns 200 with invalid data',
      () async {
    mockHttpData({'invalidKey': 'invalid_value',});

    final future = sut?.auth(params: params!);

    expect(future, throwsA(DomainError.unexpected));
  });
}
