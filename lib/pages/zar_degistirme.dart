import 'package:flutter/material.dart';
import 'dart:math';

class ZarDegistirici extends StatefulWidget {
  const ZarDegistirici({super.key});

  @override
  State<ZarDegistirici> createState() {
    return _ZarDegistirici();
  }
}

class _ZarDegistirici extends State<ZarDegistirici> {
  var aktifZar = "assets/images/dice-1.png";

  void zarAt() {
    setState(() {
      final random = Random().nextInt(6) + 1; // 1-6 arası sayı
      aktifZar = "assets/images/dice-$random.png";
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(aktifZar, width: 200),
        const SizedBox(height: 20),
        TextButton(
          onPressed: zarAt,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 29),
          ),
          child: const Text("Zar at"),
        ),
      ],
    );
  }
}
