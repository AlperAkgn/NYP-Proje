import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: EdgeInsets.all(100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField( 
                controller: _nameController,
                decoration: InputDecoration(label: Text("kullanıcı adı")),),
              SizedBox(height: 10,),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(label: Text("şifre"))),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: (){
                // BURAYI DOLDUR
              }, child: Text("Giriş yap")),
            ],
          ),
        ),
      ),
    );
  }
}