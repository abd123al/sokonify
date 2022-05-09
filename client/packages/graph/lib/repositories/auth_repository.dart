import 'package:graph/gql/generated/graphql_api.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AuthRepository {
  final GraphQLClient client;

  AuthRepository(this.client);

  signIn(SignInInput input) {
    final _options = MutationOptions(
      document: SIGN_IN_MUTATION_DOCUMENT,
      variables: SignInArguments(input: input).toJson(),
    );

    return client.mutate(_options);
  }

  signUp(SignUpInput input) {
    final _options = MutationOptions(
      document: SIGN_UP_MUTATION_DOCUMENT,
      variables: SignUpArguments(input: input).toJson(),
    );

    return client.mutate(_options);
  }

  switchStore(SwitchStoreInput input) {
    final _options = MutationOptions(
      document: SWITCH_STORE_MUTATION_DOCUMENT,
      variables: SwitchStoreArguments(input: input).toJson(),
    );

    return client.mutate(_options);
  }
}
