import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  Body({Key? key, required this.widget, this.isFullscreen = false}) : super(key: key);

  Widget widget;
  bool isFullscreen;

  @override
  Widget build(BuildContext context) {
    return !isFullscreen ? Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              border: Border.all(width: 0, color: Theme.of(context).colorScheme.secondaryContainer)
            ),
          )
        ),
        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              border: Border.all(width: 0, color: Theme.of(context).colorScheme.onPrimary,)
            ),
            child: widget,
          )
        ),
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              border: Border.all(width: 0, color: Theme.of(context).colorScheme.secondaryContainer)
            ),
          )
        ),
      ],
    ) : widget;
  }
}