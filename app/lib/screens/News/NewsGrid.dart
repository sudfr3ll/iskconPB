// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iskcon/constants/databaseService.dart';
import 'package:iskcon/constants/useMixPanel.dart';
import 'package:iskcon/screens/News/AboutNews.dart';
import 'package:shimmer/shimmer.dart';

class NewsGrid extends StatefulWidget {
  const NewsGrid({super.key});

  @override
  State<NewsGrid> createState() => _NewsGridState();
}

class _NewsGridState extends State<NewsGrid> {
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

  Future<void> sendTracking({title}) async {
    await UseMixPanel().sendTracking(
        event: "Clicked on $title in Temple News (Category level 1) in Home");
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final date = DateFormat.yMMMd('en_US');
    return FutureBuilder(
        future: DataBaseSerice().newsList(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Container(
                  padding: EdgeInsets.all(8.0),
                  height: size.height * 0.77,
                  child: GridView.builder(
                      physics: BouncingScrollPhysics(),
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
                            physics: BouncingScrollPhysics(),
                            itemCount: snapshot.data.docs.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 7.0,
                                    mainAxisSpacing: 15.0,
                                    crossAxisCount: 2,
                                    childAspectRatio: MediaQuery.of(context)
                                            .size
                                            .width /
                                        (MediaQuery.of(context).size.height /
                                            1.7)),
                            itemBuilder: (BuildContext context, int index) {
                              var data = snapshot.data.docs[index];
                              return InkWell(
                                onTap: () async {
                                  await sendTracking(title: data['title']);
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => AboutNews(
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
                                          color:
                                              Color.fromRGBO(17, 112, 114, 1),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: data['images'] != null &&
                                                  data['images'].isNotEmpty
                                              ? Image.network(
                                                  data['images'][0]['thumb'],
                                                  fit: BoxFit.fill,
                                                  loadingBuilder:
                                                      (BuildContext context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    }
                                                    return SizedBox(
                                                      height: 120,
                                                      width: size.width * 0.5,
                                                      child: Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: Colors.white,
                                                          value: loadingProgress
                                                                      .expectedTotalBytes !=
                                                                  null
                                                              ? loadingProgress
                                                                      .cumulativeBytesLoaded /
                                                                  loadingProgress
                                                                      .expectedTotalBytes!
                                                              : null,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                )
                                              : Image.asset(
                                                  'assets/images/defImage.png', // Path to your default image
                                                  fit: BoxFit.fill,
                                                  height: 120,
                                                  width: size.width * 0.5,
                                                ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            data['title'],
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .merge(TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15)),
                                          ),
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
