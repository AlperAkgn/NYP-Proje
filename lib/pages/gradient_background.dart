import 'package:flutter/material.dart';

import 'package:flutter_application_1/pages/zar_degistirme.dart';

const startAligment = Alignment.topLeft;
const endAligment = Alignment.bottomRight;

class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key, required this.colors});

  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: startAligment,
          end: endAligment,
        ),
      ),
      child: Center(child: ZarDegistirici()),
    );
  }
}
