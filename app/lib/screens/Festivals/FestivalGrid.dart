// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iskcon/constants/databaseService.dart';
import 'package:iskcon/screens/Festivals/AboutFestival.dart';
import 'package:shimmer/shimmer.dart';

class FestivalGrid extends StatefulWidget {
  const FestivalGrid({super.key});

  @override
  State<FestivalGrid> createState() => _FestivalGridState();
}

class _FestivalGridState extends State<FestivalGrid> {
  String type = 'grid';
  late bool isLoading;
  List list = [
    {'title': 'Deepotsava', 'image': 'assets/events/image1.png'},
    {'title': 'Vaikuntha Ekadashi', 'image': 'assets/events/image2.png'},
    {'title': 'Sri Nityananda Trayodashi', 'image': 'assets/events/image3.png'},
    {'title': 'Ratha Yatra', 'image': 'assets/events/image4.png'},
    {'title': 'Sri Gaura Purnima', 'image': 'assets/events/image5.png'},
    {'title': 'Sri Brahmotsava', 'image': 'assets/events/image6.png'},
    {'title': 'Akshaya Tritiya', 'image': 'assets/events/image7.png'},
    {'title': 'Garuda Panchami', 'image': 'assets/events/image8.png'},
  ];
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
    var size = MediaQuery.of(context).size;
    final date = DateFormat.yMMMd('en_US');
    return FutureBuilder(
        future: DataBaseSerice().festivalList(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return !snapshot.hasData
              ? Container(
                  padding: EdgeInsets.all(8.0),
                  height: size.height * 0.77,
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 7.0,
                              mainAxisSpacing: 15.0,
                              crossAxisCount: 2,
                              childAspectRatio: 0.89),
                      itemBuilder: (BuildContext context, int index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            color: Colors.white,
                          ),
                        );
                      }),
                )
              : Container(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.0),
                        height: size.height * 0.77,
                        child: GridView.builder(
                            itemCount: snapshot.data.docs.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 7.0,
                                    mainAxisSpacing: 15.0,
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.89),
                            itemBuilder: (BuildContext context, int index) {
                              var data = snapshot.data.docs[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => AboutFestival(
                                                data: data,
                                                title: data['title']
                                                    .toString()
                                                    .toUpperCase(),
                                              )));
                                },
                                child: Center(
                                    child: SizedBox(
                                  height: size.height,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 132,
                                        width: 188,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: NetworkImage(data.data()[
                                                            'resizedCoverImage'] ==
                                                        ''
                                                    ? data['resizedCoverImage']
                                                        ['thumb']
                                                    : data['coverImage']))),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          data['title'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .merge(TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          '${date.format(data['createdAt'].toDate())}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                              );
                            }),
                      )
                    ],
                  ),
                );
        });
  }
}
