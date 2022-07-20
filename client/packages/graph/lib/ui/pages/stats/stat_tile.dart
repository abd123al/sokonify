import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class StatTile extends StatelessWidget {
  final String title;
  final dynamic value;
  final MaterialColor? color;
  final String? subtitle;
  final GestureTapCallback? onTap;

  const StatTile({
    Key? key,
    required this.title,
    required this.value,
    this.onTap,
    this.color,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 16,
        child: Container(
          color: color?.shade50,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: AutoSizeText(
                    '$value',
                    //todo use headers in large displays
                    style: Theme.of(context).textTheme.titleLarge,
                    overflow: TextOverflow.visible,
                  ),
                ),
                Expanded(
                  child: AutoSizeText(
                    title,
                    minFontSize: 12,
                    style: Theme.of(context).textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                    ),
                    child: AutoSizeText(
                      '$subtitle',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
