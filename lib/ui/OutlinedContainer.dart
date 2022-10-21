import 'package:flutter/material.dart';

class OutlinedContainer extends StatefulWidget {
  OutlinedContainer({Key? key, required this.child, this.minimal = true, this.padding = 10.0}) : super(key: key);

  Widget child;
  bool minimal;
  double padding;

  @override
  State<OutlinedContainer> createState() => _OutlinedContainerState();
}

class _OutlinedContainerState extends State<OutlinedContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: double.infinity,
        maxWidth: double.infinity,
        minHeight: widget.minimal ? 400.0 : 0.0,
        minWidth: widget.minimal ? 600.0 : 0.0,
      ),
      margin: const EdgeInsets.all(5.0),
      padding: EdgeInsets.symmetric(vertical: widget.padding, horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12, width: 2),
        borderRadius: BorderRadius.circular(7.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: widget.child,
    );
  }
}