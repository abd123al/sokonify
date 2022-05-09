import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graph/gql/generated/graphql_api.dart';

import '../../gql/token_box.dart';
import '../../utils/consts.dart';

enum AuthState {
  loading,
  isLoggedIn,
  isLoggedOut,
  isSigningUp,
}

/// todo should we use different box?? which is un encrypted?
class AuthWrapperCubit extends Cubit<AuthState> {
  AuthWrapperCubit() : super(AuthState.loading);

  login(AuthPartsMixin parts) async {
    emit(AuthState.loading);

    final box = await tokenBox();
    box.put(tokenHiveKey, parts.accessToken);

    emit(AuthState.isLoggedIn);
  }

  check() async {
    emit(AuthState.loading);

    final box = await tokenBox();
    final result = box.get(tokenHiveKey, defaultValue: "") as String;

    if (result.isEmpty) {
      emit(AuthState.isLoggedOut);
    } else {
      emit(AuthState.isLoggedIn);
    }
  }

  logOut() async {
    emit(AuthState.loading);

    await _clear();

    emit(AuthState.isLoggedOut);
  }

  signUp() async {
    emit(AuthState.loading);

    await _clear();

    emit(AuthState.isSigningUp);
  }

  _clear() async {
    final box = await tokenBox();
    await box.delete(tokenHiveKey);
  }
}
