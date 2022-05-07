import 'package:blocitory/helpers/resource_cubit.dart';
import 'package:graph/gql/generated/graphql_api.dart';

import '../../../repositories/repositories.dart';

class SignupCubit extends ResourceCubit<String> {
  SignupCubit(this._authRepository) : super();

  final AuthRepository _authRepository;

  login(SignUpInput input) {
    super.execute(
      executor: ()  => _authRepository.signUp(input),
      parser: (r) {
        return SignUp$Mutation.fromJson(r).signUp;
      },
    );
  }
}
