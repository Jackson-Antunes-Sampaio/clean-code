import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../signup_presenter.dart';


class PasswordConfirmInput extends StatelessWidget {
  const PasswordConfirmInput({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<UIError?>(
        stream: presenter.passwordConfirmationErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            onChanged: presenter.validatePasswordConfirmation,
            decoration: InputDecoration(
              labelText: R.string.confirmPassword,
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
