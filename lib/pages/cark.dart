import 'dart:math';
import 'package:flutter/material.dart';

class Cark extends StatefulWidget {
  final List<String> isimler;
  const Cark({super.key, required this.isimler});

  @override
  State<Cark> createState() => _CarkState();
}

class _CarkState extends State<Cark> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _currentRotation = 0;
  double _finalRotation = 0;
  final Random _random = Random();

  List<String> _kazananlar = [];
  String? _sonKazanan;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    )
      ..addListener(() {
        setState(() {
          _currentRotation = _animation.value * _finalRotation;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _belirleKazanan();
        }
      });
  }

  void _belirleKazanan() {
    final kalanlar = widget.isimler
        .where((isim) => !_kazananlar.contains(isim))
        .toList();

    if (kalanlar.isEmpty) return;

    double sliceAngle = 2 * pi / kalanlar.length;
    double normalizedRotation = _currentRotation % (2 * pi);
    double pointerAngle = (3 * pi / 2 - normalizedRotation) % (2 * pi);
    if (pointerAngle < 0) pointerAngle += 2 * pi;

    int index = pointerAngle ~/ sliceAngle;
    String secilen = kalanlar[index];

    setState(() {
      _kazananlar.add(secilen);
      _sonKazanan = secilen;
    });
  }

  void _cevirCarki() {
    final kalanlar = widget.isimler
        .where((isim) => !_kazananlar.contains(isim))
        .toList();

    if (kalanlar.isEmpty || _controller.isAnimating) return;

    int randomTur = 5 + _random.nextInt(5);
    double randomEkAci = _random.nextDouble() * 2 * pi;

    _finalRotation = 2 * pi * randomTur + randomEkAci;

    _controller.reset();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final herkesKazandiMi = _kazananlar.length == widget.isimler.length;
    final kalanlar = widget.isimler
        .where((isim) => !_kazananlar.contains(isim))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Çarklı Çekiliş'),leading: IconButton(onPressed: (){
        Navigator.pop(context);
      }, icon: Icon(Icons.arrow_back)),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                RotationTransition(
                  turns: AlwaysStoppedAnimation(_currentRotation / (2 * pi)),
                  child: SizedBox(
                    width: 300,
                    height: 300,
                    child: CustomPaint(painter: CarkPainter(kalanlar)),
                  ),
                ),
                const Positioned(
                  top: 0,
                  child: Icon(Icons.arrow_drop_down,
                      size: 50, color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: herkesKazandiMi ? null : _cevirCarki,
              child: Text(herkesKazandiMi ? 'Tüm isimler seçildi' : 'Çevir'),
            ),
            const SizedBox(height: 20),
            if (_sonKazanan != null)
              Text(
                'Kazanan: $_sonKazanan',
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 20),
            const Text(
              'Kazananlar:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            for (int i = 0; i < _kazananlar.length; i++)
              Text('${i + 1}. ${_kazananlar[i]}',
                  style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class CarkPainter extends CustomPainter {
  final List<String> isimler;
  CarkPainter(this.isimler);

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    double sliceAngle = 2 * pi / isimler.length;
    final paint = Paint()..style = PaintingStyle.fill;
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < isimler.length; i++) {
      paint.color = Colors.primaries[i % Colors.primaries.length];
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        i * sliceAngle,
        sliceAngle,
        true,
        paint,
      );

      final angle = (i + 0.5) * sliceAngle;
      final offset = Offset(
        radius + radius * 0.6 * cos(angle),
        radius + radius * 0.6 * sin(angle),
      );

      textPainter.text = TextSpan(
        text: isimler[i],
        style: const TextStyle(color: Colors.white, fontSize: 16),
      );
      textPainter.layout();

      canvas.save();
      canvas.translate(offset.dx, offset.dy);
      canvas.rotate(angle + pi / 2);
      textPainter.paint(
          canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
