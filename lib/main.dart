// Tüm gerekli importlar
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/cark.dart';
import 'package:flutter_application_1/pages/draw_screen.dart';

import 'dart:math';
import 'dart:async';

import 'package:lottie/lottie.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Çekiliş Uygulaması',
      theme: ThemeData.dark(),
      home: LoginScreen(),
    );
  }
}

// Giriş Ekranı
class LoginScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Giriş")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Adınızı girin"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomeScreen(userName: nameController.text),
                  ),
                );
              },
              child: Text("Giriş Yap"),
            ),
          ],
        ),
      ),
    );
  }
}

// Ana Menü Ekranı
class HomeScreen extends StatelessWidget {
  final String userName;
  static List<String> previousWinners = [];

  HomeScreen({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hoşgeldin, $userName")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text("Çekiliş Yap"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DrawScreen(userName: userName),
                  ),
                );
              },
            ),
           
 

            ElevatedButton(
              child: Text("Oyunlar"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => GameToolsScreen()),
                );
              },
            ),
            if (previousWinners.contains(userName))
              ElevatedButton(
                child: Text("Jackpot Boss"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => JackpotBossScreen(userName: userName),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

// Çekiliş Ekranı

// Oyunlar Ekranı
class GameToolsScreen extends StatelessWidget {
  final TextEditingController minController = TextEditingController();
  final TextEditingController maxController = TextEditingController();
  final Random random = Random();

  int rollDice(int sides) => random.nextInt(sides) + 1;
  String flipCoin() => random.nextBool() ? "Yazı" : "Tura";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Oyunlar")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Zar At", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: Text("6'lık Zar"),
                  onPressed: () {
                    final result = rollDice(6);
                    final zarResmi = "assets/images/dice-$result.png";

                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Lottie animasyonu
                            Lottie.asset('assets/images/diceRoll.json',
                                width: 150, height: 150, repeat: false,
                                onLoaded: (composition) {
                                  // Animasyon tamamlanınca sonucu göstermek için gecikme
                                  Future.delayed(composition.duration, () {
                                    Navigator.of(context).pop();
                                    showDialog(
                                      context: context,
                                      builder: (_) => Dialog(
                                        child: SizedBox(child: Image.asset(zarResmi),width: 200,),
                                      ),
                                    );
                                  });
                                }),
                            SizedBox(height: 10),
                            Text("Zar atılıyor..."),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                ElevatedButton(
                  child: Text("20'lik Zar"),
                  onPressed: () {
                    final result = rollDice(20);
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(content: Text("Sonuç: $result")),
                    );
                  },
                ),
              ],
            ),
            Divider(),
            Text("Yazı Tura", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ElevatedButton(
              child: Text("At"),
              onPressed: () {
                final result = flipCoin();
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(content: Text("Sonuç: $result")),
                );
              },
            ),
            Divider(),
            Text("Rastgele Sayı Seç", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: minController,
              decoration: InputDecoration(labelText: "Min"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: maxController,
              decoration: InputDecoration(labelText: "Max"),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              child: Text("Seç"),
              onPressed: () {
                int min = int.tryParse(minController.text) ?? 0;
                int max = int.tryParse(maxController.text) ?? 100;
                final result = min + random.nextInt(max - min + 1);
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(content: Text("Sonuç: $result")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Jackpot Boss DDR Ekranı
class JackpotBossScreen extends StatefulWidget {
  final String userName;
  JackpotBossScreen({required this.userName});

  @override
  _JackpotBossScreenState createState() => _JackpotBossScreenState();
}

class _JackpotBossScreenState extends State<JackpotBossScreen> {
  int successRate = 0;
  bool isDancing = false;
  Timer? timer;

  void startDDR() {
    int beats = 0;
    const int totalBeats = 15;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        beats++;
        bool hit = Random().nextBool();
        if (hit) {
          successRate += 7;
          isDancing = true;
        } else {
          successRate -= 5;
          isDancing = false;
        }
        if (beats == totalBeats) {
          timer.cancel();
          showDialog(
            context: context,
            builder:
                (_) => AlertDialog(
                  title: Text("Jackpot Sonuçları"),
                  content:
                      successRate >= 70 && Random().nextDouble() < 0.2
                          ? Text("ÇIN ÇIN ÇIN! JACKPOT! 🎉")
                          : Text("Jackpot Kaçtı 😢"),
                ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Jackpot Boss")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isDancing ? Icons.music_note : Icons.music_off,
              size: 100,
              color: isDancing ? Colors.greenAccent : Colors.red,
            ),
            Text("Başarı Oranı: $successRate%"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: startDDR,
              child: Text("DDR Başlat (15sn)"),
            ),
          ],
        ),
      ),
    );
  }
}
