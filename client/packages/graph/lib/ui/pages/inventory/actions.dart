import 'package:flutter/material.dart';

class ItemsActions extends StatelessWidget {
  const ItemsActions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: ListView(
        shrinkWrap: true,
        children: [
          TextButton(
            onPressed: () {},
            child: const Text("Convert Stock"),
          ),
          TextButton(
            onPressed: () {},
            child: const Text("Reset Stocks to zero"),
          ),
          TextButton(
            onPressed: () {},
            child: const Text("Help"),
          ),
        ],
      ),
    );
  }
}
