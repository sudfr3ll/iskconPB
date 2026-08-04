import 'package:flutter/material.dart';

class TestYoutubeApi extends StatelessWidget {
  const TestYoutubeApi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child:
            ElevatedButton(onPressed: () {}, child: Text('Hit Youtube Api...')),
      ),
    );
  }
}
