import 'package:flutter/material.dart';

class StyledText extends StatelessWidget {
  const StyledText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text(text, style: TextStyle(fontSize: 24, color: Colors.white));
  }
}
