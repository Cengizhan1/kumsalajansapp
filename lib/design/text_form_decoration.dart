import 'package:flutter/material.dart';
import 'package:kumsakajansapp/design/constants.dart';

class BorderBox extends StatelessWidget {
  final Widget child;

  final double width, height;
  const BorderBox({
    Key? key,
    required this.child,
    required this.width,
    required this.height,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: COLOR_WHITE,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: COLOR_GREY, width: 2)),
      child: Center(
        child: child,
      ),
    );
  }
}
