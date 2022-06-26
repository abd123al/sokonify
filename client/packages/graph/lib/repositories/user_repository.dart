import 'package:graph/gql/generated/graphql_api.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UserRepository {
  final GraphQLClient client;

  UserRepository( this.client);

  fetchMe() {
    final options = QueryOptions(
      document: MeQuery().document,
    );

    return client.query(options);
  }

  editProfile(ProfileInput input) {
    final options = MutationOptions(
      document: EDIT_PROFILE_MUTATION_DOCUMENT,
      variables: EditProfileArguments(input: input).toJson(),
    );

    return client.mutate(options);
  }

  changePassword(ChangePasswordInput input) {
    final options = MutationOptions(
      document: CHANGE_PASSWORD_MUTATION_DOCUMENT,
      variables: ChangePasswordArguments(input: input).toJson(),
    );

    return client.mutate(options);
  }
}
