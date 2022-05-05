import 'package:blocitory/helpers/resource_mutation_widget.dart';
import 'package:blocitory/widgets/button.dart';
import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/auth_repository.dart';
import 'login_cubit.dart';


class LoginInPage extends StatefulWidget {
  const LoginInPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginInPageState();
  }
}

class _LoginInPageState extends State<LoginInPage> {
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: MutationBuilder<String, LoginCubit, AuthRepository>(
        blocCreator: (r) => LoginCubit(r),
        onSuccess: (context, data) {
          //BlocProvider.of<AuthCubit>(context).loginIn();
        },
        loadingWidget: const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
        builder: (context, cubit) {
          const padding = EdgeInsets.only(top: 8.0);

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 16,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Form(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        // Image.asset(
                        //   'images/logo.png',
                        //   width: 150,
                        //   height: 150,
                        // ),
                        Text(
                          'Welcome to Sokonify',
                          style: Theme.of(context).textTheme.headline5,
                          textAlign: TextAlign.center,
                        ),
                        const Divider(),
                        Text(
                          'To get started please sign in',
                          style: Theme.of(context).textTheme.subtitle1,
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: padding,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email or Username',
                            ),
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        Padding(
                          padding: padding,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Password',
                            ),
                            controller: _passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                          ),
                        ),
                        Button(
                          callback: () {
                            cubit.login(
                              SignInInput(
                                password: _passwordController.text,
                                email: _emailController.text,
                              ),
                            );
                          },
                          title: 'Sign In',
                        ),
                        const Divider(),
                        // Button(
                        //   // style: ButtonStyle(
                        //   //   backgroundColor:
                        //   //       MaterialStateProperty.all(Colors.blue),
                        //   // ),
                        //   callback: () {
                        //     cubit.login();
                        //   },
                        //   title: 'Sign in with Google',
                        // ),
                        const Text(
                          "or",
                          //style: Theme.of(context).textTheme.subtitle1,
                          textAlign: TextAlign.center,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Click here to sign up',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();

    super.dispose();
  }
}
