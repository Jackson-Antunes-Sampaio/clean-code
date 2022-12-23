import '../../../domain/entities/entities.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usercases/usercases.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteAddAccount implements AddAccount{
  final HttpClient? httpClient;
  final String? url;

  RemoteAddAccount({required this.httpClient, required this.url});

  @override
  Future<AccountEntity?> add({required AddAccountParams params}) async {
    final body = RemoteAddAccountParams.fromDomain(params).toJson();
    try{
      final httpResponse =
      await httpClient?.request(url: url!, method: 'post', body: body);
      return RemoteAccountModel.fromJson(httpResponse ?? {}).toEntity();
    }on HttpError catch(error){
      throw error == HttpError.forbidden
          ?  DomainError.emailInUser
          :  DomainError.unexpected;
    }

  }
}

class RemoteAddAccountParams {
  final String email;
  final String name;
  final String passwordConfirm;
  final String password;

  RemoteAddAccountParams(
      {required this.email,
      required this.password,
      required this.name,
      required this.passwordConfirm});

  factory RemoteAddAccountParams.fromDomain(AddAccountParams params) =>
      RemoteAddAccountParams(
          email: params.email,
          password: params.password,
          name: params.name,
          passwordConfirm: params.passwordConfirmation);

  Map toJson() => {
    "email": email,
    "password": password,
    "name" : name,
    "passwordConfirmation" : passwordConfirm
  };
}
