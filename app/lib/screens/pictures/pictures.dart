import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class Pictures extends StatefulWidget {
  final String? title;
  const Pictures({super.key, this.title});

  @override
  State<Pictures> createState() => _PicturesState();
}

class _PicturesState extends State<Pictures> {
  List list = [
    {'title': 'VYASA PUJA', 'image': 'assets/pictures/Rectangle71.png'},
    {
      'title': 'DIKSHA CEREMONYMIRA ROAD',
      'image': 'assets/pictures/Rectangle75.png'
    },
    {
      'title': 'NEW TEMPLEOPENING PATNA',
      'image': 'assets/pictures/Rectangle78.png'
    },
    {
      'title': 'BUREAU MEETING,JUHU, MUMBAI',
      'image': 'assets/pictures/Rectangle79.png'
    },
    {
      'title': 'INITIATION CEREMONY',
      'image': 'assets/pictures/Rectangle82.png'
    },
    {
      'title': 'TRANSCENDENTALSMILE',
      'image': 'assets/pictures/Rectangle83.png'
    },
  ];
  late bool isLoading;
  @override
  void initState() {
    isLoading = true;
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('yyyy');
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 46,
        title: Text(
          widget.title!,
          style: TextStyle(fontSize: 15),
        ),
        actions: [Image.asset('assets/images/logo2.png')],
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        child: GridView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: list.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.9,
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 20.0,
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) {
            return isLoading == true
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      color: Colors.white,
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(10), // Image border
                                child: Image.asset(
                                  list[index]['image'],
                                  fit: BoxFit.fitWidth,
                                  width: size.width * 0.5,
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    date.format(DateTime.now()),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          list[index]['title'],
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}
