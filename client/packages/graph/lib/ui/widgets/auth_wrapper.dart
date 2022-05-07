import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../pages/auth/auth_cubit.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/signup_page.dart';

class AuthWrapper extends StatelessWidget {
  final Widget child;

  const AuthWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state == AuthState.isLoggedOut) {
          return const LoginInPage();
        } else if (state == AuthState.isSigningUp) {
          return const SignupPage();
        } else if (state == AuthState.isLoggedIn) {
          return child;
        } else {
          return Scaffold(
            backgroundColor: Theme.of(context).primaryColorDark,
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).backgroundColor,
              ),
            ),
          );
        }
      },
    );
  }
}
