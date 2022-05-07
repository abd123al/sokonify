import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthState {
  loading,
  isLoggedIn,
  isLoggedOut,
  isSigningUp,
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState.loading);

  loginIn() {
    emit(AuthState.isLoggedIn);
  }

  check() async {
    emit(AuthState.isLoggedIn);
  }

  logOut() async {
    emit(AuthState.isLoggedOut);
  }

  signUp() {
    emit(AuthState.isSigningUp);
  }
}
