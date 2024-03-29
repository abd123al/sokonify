import 'package:blocitory/helpers/resource_mutation_widget.dart';
import 'package:blocitory/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/auth_repository.dart';
import '../../widgets/auth_wrapper_cubit.dart';
import 'auth_cubit.dart';

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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: MutationBuilder<AuthPartsMixin, LoginCubit, AuthRepository>(
        blocCreator: (r) => LoginCubit(r),
        onSuccess: (context, data) {
          BlocProvider.of<AuthWrapperCubit>(context).login(data);
        },
        loadingWidget: const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
        showPopUpSuccess: false,
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
                    key: _formKey,
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
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (s) {
                              if ((s?.length ?? 0) < 1) {
                                return "Type username/Email here..";
                              }
                              return null;
                            },
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
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (s) {
                              if ((s?.length ?? 0) < 8) {
                                return "New Password must contain at least 8 characters";
                              }
                              return null;
                            },
                          ),
                        ),
                        Button(
                          callback: () {
                            if (_formKey.currentState!.validate()) {
                              cubit.signIn(
                                SignInInput(
                                  password: _passwordController.text,
                                  login: _emailController.text,
                                ),
                              );
                            }
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
                          onPressed: () {
                            BlocProvider.of<AuthWrapperCubit>(context).signUp();
                          },
                          child: const Text(
                            'New here? Click here to sign up',
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
