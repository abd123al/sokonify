import 'package:flutter/material.dart';

class CreateButton extends StatelessWidget {
  const CreateButton({
    Key? key,
    required this.onPressed,
    required this.title,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).secondaryHeaderColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextButton(
              onPressed: onPressed,
              child: Text("Create $title"),
            ),
          )
        ],
      ),
    );
  }
}
