import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iskcon/constants/databaseService.dart';
import 'package:iskcon/screens/audio/bookReading.dart';
import 'package:shimmer/shimmer.dart';

class AudioCategoryL3 extends StatefulWidget {
  final String title;
  final String id1;
  final String id2;
  const AudioCategoryL3(
      {super.key, required this.title, required this.id1, required this.id2});

  @override
  State<AudioCategoryL3> createState() => _AudioCategoryL3State();
}

class _AudioCategoryL3State extends State<AudioCategoryL3> {
  List<Color> colors = [
    Colors.amber.shade100,
    Colors.blue.shade100,
    Colors.purple.shade100,
    Colors.green.shade100,
    Colors.red.shade100
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 46,
        title: Text(
          widget.title,
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
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future:
                DataBaseSerice().categoryL3(widget.id1, widget.id2, 'audios'),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Container(
                      child: Column(
                        children: [
                          // Shimmer.fromColors(
                          //   baseColor: Colors.grey[300]!,
                          //   highlightColor: Colors.grey[100]!,
                          //   child: Container(
                          //     height: size.height * 0.25,
                          //     decoration: BoxDecoration(
                          //       color: Colors.white,
                          //       borderRadius: BorderRadius.only(
                          //           bottomLeft: Radius.circular(50)),
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 6,
                              itemBuilder: (context, index) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 16),
                                      child: Container(
                                        height: 50,
                                        color: Colors.white,
                                      )),
                                );
                              }),
                        ],
                      ),
                    )
                  : Container(
                      child: Column(
                        children: [
                          // Stack(
                          //   children: [
                          //     Container(
                          //       height: size.height * 0.25,
                          //       decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.only(
                          //               bottomLeft: Radius.circular(50)),
                          //           image: DecorationImage(
                          //               fit: BoxFit.cover,
                          //               image: NetworkImage(
                          //                   'assets/pictures/audio.png'))),
                          //     ),
                          //     Container(
                          //       height: size.height * 0.25,
                          //       decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.only(
                          //               bottomLeft: Radius.circular(50)),
                          //           color: Colors.black.withOpacity(0.4)),
                          //     )
                          //   ],
                          // ),
                          SizedBox(
                            height: 10,
                          ),
                          ListView.builder(
                              itemCount: snapshot.data.docs.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var data = snapshot.data.docs[index];
                                return Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  AudioBookReading(
                                                    title: data['name'],
                                                    id: data.id,
                                                  )));
                                    },
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.amber,
                                    ),
                                    leading: Image.asset(
                                      'assets/features/music.png',
                                      height: 27,
                                      color: Colors.amber,
                                    ),
                                    tileColor: colors[index],
                                    title: Text(
                                      data['name'],
                                      style: TextStyle(
                                          color: Colors.amber,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                              }),
                        ],
                      ),
                    );
            }),
      ),
    );
  }
}
