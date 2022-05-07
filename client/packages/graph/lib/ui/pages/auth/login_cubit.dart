import 'package:blocitory/helpers/resource_cubit.dart';
import 'package:graph/gql/generated/graphql_api.dart';

import '../../../repositories/repositories.dart';

class LoginCubit extends ResourceCubit<SignIn$Mutation$AuthPayload> {
  LoginCubit(this._authRepository) : super();

  final AuthRepository _authRepository;

  login(SignInInput input) {
    super.execute(
      executor: ()  => _authRepository.signIn(input),
      parser: (r) {
        return SignIn$Mutation.fromJson(r).signIn;
      },
    );
  }
}
