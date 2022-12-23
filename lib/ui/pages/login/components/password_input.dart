import '../../../helpers/helpers.dart';
import '../login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class PasswordInput extends StatelessWidget {
  const PasswordInput({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<UIError?>(
        stream: presenter.passwordErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            onChanged: presenter.validatePassword,
            decoration: InputDecoration(
              labelText: R.string.password,
              errorText: snapshot.data?.description,
              icon: Icon(
                Icons.lock,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
            obscureText: true,
          );
        });
  }
}
