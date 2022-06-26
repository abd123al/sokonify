import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/category_repository.dart';
import '../category/categories_list_cubit.dart';
import 'create_category_cubit.dart';

class CategoryForm extends StatefulWidget {
  const CategoryForm({
    Key? key,
    required this.category,
    required this.id,
    required this.type,
  }) : super(key: key);

  final Category$Query$Category? category;
  final CategoryType type;
  final int? id;

  @override
  State<StatefulWidget> createState() {
    return _CreateCategoryPageState();
  }
}

class _CreateCategoryPageState extends State<CategoryForm> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  late bool isEdit;

  @override
  void initState() {
    super.initState();
    isEdit = widget.category != null && widget.id != null;
    _nameController.text = widget.category?.name ?? "";
    _descController.text = widget.category?.description ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            TextField(
              autofocus: true,
              controller: _nameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Category name',
                  hintText: 'Enter Category name',
                  helperText: "eg. Antibiotics, Shoes"),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              controller: _descController,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              maxLength: 250,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Category Description (Optional)',
                hintText: "Anything you like here",
                helperText:
                    "This can help you remember what category is about.",
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            MutationBuilder<CreateCategory$Mutation$Category,
                CreateCategoryCubit, CategoryRepository>(
              blocCreator: (r) => CreateCategoryCubit(r),
              onSuccess: (context, data) {
                if (isEdit) {
                  BlocProvider.of<CategoriesListCubit>(context).updateItem(
                    (l) => l.firstWhere((e) => e.id == widget.id),
                    Categories$Query$Category.fromJson(data.toJson()),
                  );
                } else {
                  BlocProvider.of<CategoriesListCubit>(context).addItem(
                      Categories$Query$Category.fromJson(data.toJson()));
                }
              },
              pop: true,
              builder: (context, cubit) {
                return Button(
                  padding: EdgeInsets.zero,
                  callback: () {
                    final input = CategoryInput(
                      name: _nameController.text,
                      description: _descController.text,
                      type: widget.type,
                    );

                    if (isEdit) {
                      cubit.edit(widget.id!, input);
                    } else {
                      cubit.create(input);
                    }
                  },
                  title: 'Submit',
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }
}
