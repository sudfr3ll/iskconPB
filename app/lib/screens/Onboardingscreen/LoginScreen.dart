import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const pathName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    "https://w0.peakpx.com/wallpaper/687/933/HD-wallpaper-iskcon-bengaluru-iskon-karnataka-temple-thumbnail.jpg"),
                fit: BoxFit.cover),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.45,
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.55,
                ),
                color: Colors.purple[800],
                child: Text('avsda'),
              ),
            ],
          )),
    );
  }
}
