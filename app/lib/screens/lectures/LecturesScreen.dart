import 'package:flutter/material.dart';
import 'package:iskcon/screens/lectures/LecturesTile.dart';

class LecturesScreen extends StatelessWidget {
  const LecturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List list = [
      {
        'title': 'Sri Krishna Book Reading',
        "imgUrl":
            'https://tripsbharat.com/wp-content/uploads/2020/09/iskcon-temple-in-delhi.jpg',
      },
      {
        'title': 'Brhad Bhagavatamrita',
        "imgUrl":
            'https://iskconstatic.s3.ap-south-1.amazonaws.com/iskconvrindavan/pages/About-Us-946316be49c890d.jpeg',
      },
      {
        'title': 'Seminars',
        "imgUrl":
            'https://yometro.com/images/places/iskcon-temple-navi-mumbai.jpg'
      },
      {
        'title': 'Daily Morning Classes',
        "imgUrl": 'https://iskconnews.org/media/images/2021/02-Feb/juhu2.png'
      },
    ];

    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('LECTURES'),
        centerTitle: true,
        actions: [Image.asset('assets/images/logo2.png')],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          height: size.height,
          child: GridView.builder(
            itemCount: list.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1),
            itemBuilder: ((context, index) {
              return LecturesTile(
                imgUrl: list[index]['imgUrl'],
                imgText: list[index]['title'],
              );
            }),
          ),
        ),
      ),
    );
  }
}
