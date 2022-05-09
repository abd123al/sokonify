import 'package:blocitory/helpers/resource_cubit.dart';
import 'package:graph/gql/generated/graphql_api.dart';

import '../../../repositories/repositories.dart';

class LoginCubit extends ResourceCubit<AuthPartsMixin> {
  LoginCubit(this._authRepository) : super();

  final AuthRepository _authRepository;

  signIn(SignInInput input) {
    super.execute(
      executor: ()  => _authRepository.signIn(input),
      parser: (r) {
        return SignIn$Mutation.fromJson(r).signIn;
      },
    );
  }

  signUp(SignUpInput input) {
    super.execute(
      executor: ()  => _authRepository.signUp(input),
      parser: (r) {
        return SignUp$Mutation.fromJson(r).signUp;
      },
    );
  }
}
