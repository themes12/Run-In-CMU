import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runinmor/provider/auth_provider.dart';
import 'package:sign_button/sign_button.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Center(
        child: SignInButton(
          buttonType: ButtonType.google,
          buttonSize: ButtonSize.medium,
          onPressed: () {
            auth.handleGoogleSignin();
          },
        ),
      ),
    );
  }
}
