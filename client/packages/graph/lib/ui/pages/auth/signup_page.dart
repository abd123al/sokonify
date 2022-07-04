import 'package:blocitory/helpers/resource_mutation_widget.dart';
import 'package:blocitory/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/auth_repository.dart';
import '../../widgets/auth_wrapper_cubit.dart';
import 'auth_cubit.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SignupPageState();
  }
}

class _SignupPageState extends State<SignupPage> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
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
                              helperText: "Example: Bikolimana Sabibi.",
                            ),
                            controller: _nameController,
                            keyboardType: TextInputType.text,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (s) {
                              if ((s?.length ?? 0) < 4) {
                                return "Name must contain at least 4 characters";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: padding,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              helperText: "Example: example@gmail.com",
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (s) {
                              if (s == null ||
                                  !s.contains("@") ||
                                  !s.contains(".")) {
                                return "Please enter valid email";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: padding,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'New Password',
                              helperText:
                                  "Password should contain at least 8 characters.",
                            ),
                            controller: _newPasswordController,
                            keyboardType: TextInputType.visiblePassword,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            obscureText: true,
                            validator: (s) {
                              if ((s?.length ?? 0) < 8) {
                                return "New Password must contain at least 8 characters";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: padding,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Confirm Password',
                              helperText:
                                  "This should match with above password",
                            ),
                            controller: _confirmPasswordController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            validator: (s) {
                              if (s != _newPasswordController.text) {
                                return "Password don't match!";
                              }
                              return null;
                            },
                          ),
                        ),
                        Button(
                          callback: () {
                            if (_formKey.currentState!.validate()) {
                              cubit.signUp(
                                SignUpInput(
                                  password: _newPasswordController.text,
                                  email: _emailController.text,
                                  name: _nameController.text,
                                ),
                              );
                            }
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
                            BlocProvider.of<AuthWrapperCubit>(context).logOut();
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
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    _nameController.dispose();

    super.dispose();
  }
}
