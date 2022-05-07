import 'package:blocitory/helpers/resource_mutation_widget.dart';
import 'package:blocitory/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/nav.dart';
import '../../../repositories/auth_repository.dart';
import 'auth_cubit.dart';
import 'signup_cubit.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SignupPageState();
  }
}

class _SignupPageState extends State<SignupPage> {
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: MutationBuilder<SignUp$Mutation$AuthPayload, SignupCubit,
          AuthRepository>(
        blocCreator: (r) => SignupCubit(r),
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
                        Text(
                          'Welcome to Sokonify',
                          style: Theme.of(context).textTheme.headline5,
                          textAlign: TextAlign.center,
                        ),
                        const Divider(),
                        Text(
                          'To get started please sign up',
                          style: Theme.of(context).textTheme.subtitle1,
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: padding,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Full name',
                            ),
                            controller: _nameController,
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        Padding(
                          padding: padding,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email',
                            ),
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        Padding(
                          padding: padding,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'New Password',
                            ),
                            controller: _passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                          ),
                        ),
                        Padding(
                          padding: padding,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Confirm Password',
                            ),
                            controller: _passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                          ),
                        ),
                        Button(
                          callback: () {
                            cubit.login(
                              SignUpInput(
                                password: _passwordController.text,
                                email: _emailController.text,
                                name: _nameController.text,
                              ),
                            );
                          },
                          title: 'Sign Up',
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
                            BlocProvider.of<AuthCubit>(context).logOut();
                          },
                          child: const Text(
                            'Have an account? Click here to sign in',
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
    _nameController.dispose();

    super.dispose();
  }
}
