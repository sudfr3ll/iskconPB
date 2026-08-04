// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iskcon/routes/routes_view.dart';

class SplashScreem extends StatefulWidget {
  const SplashScreem({super.key});

  @override
  State<SplashScreem> createState() => _SplashScreemState();
}

class _SplashScreemState extends State<SplashScreem> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 1),
        () => Navigator.of(context).pushNamedAndRemoveUntil(
            RoutesView.HOME, (Route<dynamic> route) => false));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Image.asset(
          'assets/images/splashpb.png',
          fit: BoxFit.cover,
        ),
      );
    });
  }
}
