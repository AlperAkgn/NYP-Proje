import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/pages/cark.dart';
import 'package:flutter_application_1/pages/on_ayar.dart';

class DrawScreen extends StatefulWidget {
  final String userName;
  final OnAyar? kayitli;
  const DrawScreen({required this.userName, this.kayitli});

  @override
  State<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  List<String> participants = [];
  String? winner;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.kayitli != null && widget.kayitli!.kisiler.isNotEmpty) {
      participants = widget.kayitli!.kisiler;
    }
  }

  void pickWinner() {
    final random = Random();
    setState(() {
      winner = participants[random.nextInt(participants.length)];
      HomeScreen.previousWinners.add(winner!);
    });
  }

  TextEditingController _controller = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  List<String> kazananlar = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Çekiliş Ekranı"),
        actions: [
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (contex) => AlertDialog(
                      content: TextField(
                        decoration: InputDecoration(
                          label: Text("Çekiliş ön ayar adı giriniz"),
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            //Veri tabnı bağlantısı yapılacak
                            Navigator.pop(context);
                          },
                          child: Text("Kaydet"),
                        ),
                      ],
                    ),
              );
            },
            child: Text("Kaydet"),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(controller: _controller),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_controller.text.isEmpty) return;
                    setState(() {
                      participants.add(_controller.text);
                      _controller.clear();
                    });
                  },
                  child: Text("Ekle"),
                ),
                SizedBox(height: 10, width: 10),
                ElevatedButton(
                  onPressed: () {
                                  
                                  
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              Cark(isimler: participants),
                                    ),
                                  ).then((_) {
                                    kazananlar = [];
                                  });
                    
                  },
                  child: Text("Çarkıfelek"),
                ),
              ElevatedButton(onPressed: (){
                showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            content: TextField(
                              controller: _numberController,
                              decoration: InputDecoration(
                                label: Text("Kazanan sayısı girin"),
                              ),
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Random ran = Random();
                                  for (
                                    var i = 0;
                                    i < int.parse(_numberController.text);
                                    i++
                                  ) {
                                    int sayi = ran.nextInt(participants.length);
                                    kazananlar.add(participants[sayi]);
                                  }
                                  Navigator.pop(context);
                                  showDialog(context: context, builder: (context) => Dialog(child: SizedBox(
                                    height: MediaQuery.of(context).size.height*0.6,
                                    width: MediaQuery.of(context).size.height*0.8,
                                    child:  
                                    Expanded(child: ListView.builder(itemCount: 
                                    kazananlar.length, itemBuilder: (context,i) => ListTile(title: Text(kazananlar[i]),)))
                                  ,),)).then((_){
                                    kazananlar.clear();
                                  });
                                },
                                child: Text("Çekiliş Yap"),
                              ),
                            ],
                          ),
                    );
              }, child: Text("Çekiliş"))],
            ),
            Expanded(
              //width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                itemCount: participants.length,
                itemBuilder:
                    (context, i) => ListTile(
                      leading: Icon(Icons.person),
                      title: Text(participants[i]),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
