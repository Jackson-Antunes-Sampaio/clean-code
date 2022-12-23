
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../ui/components/components.dart';
import '../ui/helpers/i18n/resources.dart';
import 'factories/factories.dart';

//mango@gmail.com 12345
void main() async {

  R.load(const Locale('en', 'US'));
  Provider.debugCheckInvalidValueType = null;


  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // await CustomFirebaseMessaging().inicialize();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final routeObserver = Get.put<RouteObserver>(RouteObserver<PageRoute>());

    return GetMaterialApp(
      title: '4dev',
      debugShowCheckedModeBanner: false,
      theme: makeAppTheme(),
      initialRoute: '/',

      navigatorObservers: [routeObserver],
      getPages: [
        GetPage(name: '/', page: makeSplashPage, transition: Transition.fade),
        GetPage(name: '/login', page: makeLoginPage, transition: Transition.fadeIn),
        GetPage(name: '/signup', page: makeSignUpPage),
        GetPage(
            name: '/surveys',
            page: makeSurveysPage, transition: Transition.fadeIn)
      ],
    );
  }
}
