import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/category_repository.dart';
import 'categories_list_cubit.dart';
import 'create_category_cubit.dart';

class CreateCategoryPage extends StatelessWidget {
  const CreateCategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Category"),
      ),
      body: const CreateCategoryWidget(),
    );
  }
}

///todo do weed need this or delete it??
class CreateCategoryWidget extends StatefulWidget {
  const CreateCategoryWidget({
    Key? key,
    this.message,
    this.onSuccess,
  }) : super(key: key);

  /// If users have no stores, they will be greeted by this msg
  /// which will aid them in creating new store.
  final String? message;

  /// When users have no default store we are going to switch to this
  /// one automatically
  final Function(BuildContext, CategoryPartsMixin)? onSuccess;

  @override
  State<StatefulWidget> createState() {
    return _CreateCategoryPageState();
  }
}

class _CreateCategoryPageState extends State<CreateCategoryWidget> {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 16,
      child: Form(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (widget.message != null)
                Text(
                  widget.message!,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              const Divider(),
              TextField(
                autofocus: true,
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Facility name',
                  hintText: 'Enter your Shop name',
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              MutationBuilder<CreateCategory$Mutation$Category,
                  CreateCategoryCubit, CategoryRepository>(
                blocCreator: (r) => CreateCategoryCubit(r),
                onSuccess: widget.onSuccess ??
                    (context, data) {
                      BlocProvider.of<CategoriesListCubit>(context).addCategory(
                          Categories$Query$Category.fromJson(data.toJson()));
                    },
                pop: widget.onSuccess == null,
                builder: (context, cubit) {
                  return Button(
                    padding: EdgeInsets.zero,
                    callback: () {
                      cubit.submit(
                        CategoryInput(
                          name: _nameController.text,
                        ),
                      );
                    },
                    title: 'Submit',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
