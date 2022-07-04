import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/repositories.dart';

class ChangePasswordCubit extends ResourceCubit<bool> {
  ChangePasswordCubit(this._repository) : super();
  final UserRepository _repository;

  submit(ChangePasswordInput input) {
    super.execute(
      executor: () => _repository.changePassword(input),
      parser: (r) {
        return ChangePassword$Mutation.fromJson(r).changePassword;
      },
    );
  }
}
