import 'package:curso_clean_solid/ui/helpers/helpers.dart';
import 'package:curso_clean_solid/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<bool?>(
        stream: presenter.isFormValidStream,
        builder: (context, snapshot) {
          return ElevatedButton(
            onPressed: snapshot.data == true ? presenter.signUp : null,
            child: Text(R.string.addAccount.toUpperCase()),
          );
        });
  }
}
