import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../repositories/user_repository.dart';

class UserBuilderCubit extends ResourceCubit<Me$Query$User> {
  final UserRepository _repository;

  UserBuilderCubit(this._repository) : super();

  fetch() {
    super.execute(
      executor: () => _repository.fetchMe(),
      parser: (r) => Me$Query.fromJson(r).me,
    );
  }

  edit(ProfileInput input) {
    super.execute(
      executor: () => _repository.editProfile( input),
      parser: (r) {
        final result = EditProfile$Mutation.fromJson(r).editProfile;
        return Me$Query$User.fromJson(result.toJson());
      },
    );
  }
}
