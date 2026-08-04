import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xff9C5AB1),
          Color(0xff9C5AB1),

          // Color.fromRGBO(192, 175, 233, 1),
          // Color.fromRGBO(119, 97, 172, 1),
        ])),
      ),
      toolbarHeight: 46,
      title: Text(
        title,
        style: TextStyle(fontSize: 15),
      ),
      actions: [
        Image.asset(
          'assets/images/logo.png',
          height: 40,
          width: 40,
        ),
        SizedBox(
          width: 10,
        )
      ],
      centerTitle: true,
    );
  }
}
