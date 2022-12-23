import 'package:get/get.dart';

import '../../domain/usercases/load_current_account.dart';
import '../../ui/pages/splash/splash_presenter_dart.dart';

class GetxSplashPresenter implements SplashPresenter {
  late LoadCurrentAccount loadCurrentAccount;
  final _navigateTo = RxnString();

  GetxSplashPresenter({required this.loadCurrentAccount});

  @override
  Stream<String?>? get navigateToStream => _navigateTo.stream;

  @override
  Future<void>? checkAccount({int durationSecond = 2}) async {
    await Future.delayed(Duration(seconds: durationSecond));
    try{
      final account = await loadCurrentAccount.load();
      //account?.token != null  ||
      _navigateTo.value =  account?.token.isNotEmpty == true ? '/surveys' : '/login' ;
    }catch(e){
      _navigateTo.value = '/login';
    }

  }
}
