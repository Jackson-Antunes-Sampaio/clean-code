import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../ui/helpers/helpers.dart';
import '../../components/components.dart';
import 'components/components.dart';
import 'login_presenter.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key, required this.presenter}) : super(key: key);

  final LoginPresenter? presenter;


  @override
  Widget build(BuildContext context) {

    void _hideKeyboard(){
      final currectFocus = Focus.of(context);
      if(!currectFocus.hasPrimaryFocus){
        currectFocus.unfocus();
      }
    }

    return Scaffold(
      body: Builder(
        builder: (context) {
          presenter?.isLoadingStream?.listen((isLoading) {
            if (isLoading == true) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });
          presenter?.mainErrorStream?.listen((error) {
            if (error != null) {
              showErrorMessage(context, error.description);
            }
          });
          presenter?.navigateToStream?.listen((page) {
            if (page?.isNotEmpty == true) {
              Get.offAllNamed(page!);
            }
          });
          return GestureDetector(
            onTap: _hideKeyboard ,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const LoginHeader(),
                  HeadLine1(text: R.string.login),
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Form(
                      child: Provider(
                        create: (BuildContext context) {
                          return presenter;
                        },
                        child: Column(
                          children: [
                            const EmailInput(),
                            const Padding(
                              padding: EdgeInsets.only(top: 8, bottom: 32),
                              child: PasswordInput(),
                            ),
                            const LoginButton(),
                            TextButton.icon(
                              onPressed: presenter?.goToSignUp,
                              icon: const Icon(Icons.person),
                              label: Text(R.string.addAccount),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


