import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iskcon/constants/databaseService.dart';
import 'package:iskcon/constants/useMixPanel.dart';
import 'package:iskcon/screens/audio/audioplaylist.dart';
import 'package:iskcon/screens/audio/bookReading.dart';
import 'package:iskcon/screens/audio/categoryL2.dart';
import 'package:shimmer/shimmer.dart';

class AudioCategoryL1 extends StatefulWidget {
  final String title;
  const AudioCategoryL1({super.key, required this.title});

  @override
  State<AudioCategoryL1> createState() => _AudioCategoryL1State();
}

class _AudioCategoryL1State extends State<AudioCategoryL1> {
  List<Color> colors = [
    Colors.amber.shade50,
    Colors.blue.shade50,
    Colors.purple.shade50,
    Colors.green.shade50,
    Colors.red.shade50
  ];

  Future<void> sendTracking({title}) async {
    await UseMixPanel().sendTracking(
        event: "Clicked on $title in Audios (Category level 1) in Home");
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 46,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Color(0xff9C5AB1),
            Color(0xff9C5AB1),
          ])),
        ),
        title: Text(
          'AUDIO',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton.icon(
              onPressed: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => AudioPlayList()));
              },
              icon: Icon(
                Icons.library_music,
                color: Colors.white,
              ),
              label: Text(
                'Playlist',
                style: TextStyle(color: Colors.white),
              ))
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: FutureBuilder(
            future: DataBaseSerice().categoryL1('audios'),
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
                          GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio:
                                    MediaQuery.of(context).size.width / 370,
                                crossAxisSpacing: 20.0,
                                mainAxisSpacing: 15.0,
                                crossAxisCount: 2,
                              ),
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
                          // Container(
                          //   height: size.height * 0.25,
                          //   decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.only(
                          //           bottomLeft: Radius.circular(50)),
                          //       image: DecorationImage(
                          //           fit: BoxFit.cover,
                          //           image: NetworkImage(
                          //               'assets/pictures/audio.png'))),
                          // ),
                          // Container(
                          //   height: size.height * 0.25,
                          //   decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.only(
                          //           bottomLeft: Radius.circular(50)),
                          //       color: Colors.black.withOpacity(0.4)),
                          // )
                          //   ],
                          // ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          snapshot.data.docs.length == 0
                              ? Center(
                                  child: Text('No Data Found'),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: GridView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio:
                                            MediaQuery.of(context).size.width /
                                                375,
                                        crossAxisSpacing: 20.0,
                                        mainAxisSpacing: 15.0,
                                        crossAxisCount: 2,
                                      ),
                                      itemCount: snapshot.data.docs.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        var data = snapshot.data.docs[index];
                                        return InkWell(
                                            onTap: () async {
                                              await sendTracking(
                                                  title: data['name']);
                                              data.data()['isSubCategory'] ==
                                                      true
                                                  ? Navigator.push(
                                                      context,
                                                      CupertinoPageRoute(
                                                          builder: (context) =>
                                                              AudioCategoryL2(
                                                                title: data[
                                                                    'name'],
                                                                id: data.id,
                                                              )))
                                                  : Navigator.push(
                                                      context,
                                                      CupertinoPageRoute(
                                                          builder: (context) =>
                                                              AudioBookReading(
                                                                title: data[
                                                                    'name'],
                                                                id: data.id,
                                                              )));
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      17, 112, 114, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Column(
                                                children: [
                                                  Stack(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10)),
                                                        child: Image.network(
                                                          data.data()['resizedCoverImage'] !=
                                                                      null &&
                                                                  data.data()['resizedCoverImage']
                                                                          [
                                                                          'thumb'] !=
                                                                      null
                                                              ? data['resizedCoverImage']
                                                                  ['thumb']
                                                              : data[
                                                                  'coverImage'],
                                                          fit: BoxFit.cover,
                                                          height: 120,
                                                          width:
                                                              size.width * 0.5,
                                                          loadingBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  Widget child,
                                                                  ImageChunkEvent?
                                                                      loadingProgress) {
                                                            if (loadingProgress ==
                                                                null) {
                                                              return child;
                                                            }
                                                            return SizedBox(
                                                              height: 120,
                                                              width:
                                                                  size.width *
                                                                      0.5,
                                                              child: Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color: Colors
                                                                      .white,
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
                                                        ),
                                                      ),
                                                      // Align(
                                                      //     alignment: Alignment
                                                      //         .topRight,
                                                      //     child: IconButton(
                                                      //         onPressed: () {
                                                      //           showModalBottomSheet(
                                                      //               shape:
                                                      //                   RoundedRectangleBorder(
                                                      //                 borderRadius: BorderRadius.only(
                                                      //                     topLeft: Radius.circular(
                                                      //                         20),
                                                      //                     topRight:
                                                      //                         Radius.circular(20)),
                                                      //               ),
                                                      //               enableDrag:
                                                      //                   true,
                                                      //               context:
                                                      //                   context,
                                                      //               builder:
                                                      //                   (context) =>
                                                      //                       Padding(
                                                      //                         padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                      //                         child: ShowDescription(data: data, description: data['description'], image: data.data()['resizedCoverImage'] != null && data.data()['resizedCoverImage']['thumb'] != null ? data['resizedCoverImage']['thumb'] : data['coverImage'], title: data['name']),
                                                      //                       ));
                                                      //         },
                                                      //         icon: Icon(
                                                      //           Icons
                                                      //               .info_outline,
                                                      //           color: Colors
                                                      //               .white,
                                                      //           size: 20,
                                                      //         )))
                                                    ],
                                                  ),
                                                  Flexible(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 8.0),
                                                      child: Center(
                                                        child: Text(
                                                          data['name'],
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16),
                                                          textAlign:
                                                              TextAlign.center,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )

                                            //  Padding(
                                            //   padding: EdgeInsets.symmetric(
                                            //       vertical: 8.0, horizontal: 8.0),
                                            //   child: ClipRRect(
                                            //     borderRadius:
                                            //         BorderRadius.circular(10),
                                            //     child: Container(
                                            //       height: 70,
                                            //       color: Colors.white,
                                            //       child: Row(
                                            //         children: <Widget>[
                                            //           Container(
                                            //             color: Colors.amber.shade500,
                                            //             width: 70,
                                            //             height: 70,
                                            //             child: Center(
                                            //               child: Image.asset(
                                            //                 'assets/features/music.png',
                                            //                 height: 27,
                                            //               ),
                                            //             ),
                                            //           ),
                                            //           // Container(
                                            //           //   color: Colors.amber.shade500,
                                            //           //   width: 70,
                                            //           //   height: 70,
                                            //           //   child: Icon(Icons.music_note,
                                            //           //       color: Colors.white),
                                            //           // ),
                                            //           SizedBox(width: 10),
                                            //           Expanded(
                                            //             child: Column(
                                            //               mainAxisAlignment:
                                            //                   MainAxisAlignment
                                            //                       .center,
                                            //               crossAxisAlignment:
                                            //                   CrossAxisAlignment
                                            //                       .start,
                                            //               children: <Widget>[
                                            //                 Text(
                                            //                   data['name'],
                                            //                   style: Theme.of(context)
                                            //                       .textTheme
                                            //                       .titleMedium,
                                            //                 ),
                                            //               ],
                                            //             ),
                                            //           ),
                                            //           Icon(Icons.arrow_forward_ios,
                                            //               color: Colors.black54),
                                            //         ],
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),

                                            );
                                        // ListTile(
                                        //   onTap: () {
                                        //     data['isSubCategory'] == true
                                        //         ? Navigator.push(
                                        //             context,
                                        //             CupertinoPageRoute(
                                        //                 builder: (context) =>
                                        //                     AudioCategoryL2(
                                        //                       title: data['name'],
                                        //                       id: data.id,
                                        //                     )))
                                        //         : Navigator.push(
                                        //             context,
                                        //             CupertinoPageRoute(
                                        //                 builder: (context) =>
                                        //                     AudioBookReading(
                                        //                       title: data['name'],
                                        //                       id: data.id,
                                        //                     )));
                                        //   },
                                        //   trailing: Icon(
                                        //     Icons.arrow_forward_ios,
                                        //   ),
                                        //   leading: Container(
                                        //     width: 80,
                                        //     color: Colors.green,
                                        //     child: Image.asset(
                                        //       'assets/features/music.png',
                                        //       height: 27,
                                        //     ),
                                        //   ),
                                        //   tileColor: Colors.green,
                                        //   title: Text(
                                        //     data['name'],
                                        //     style: TextStyle(
                                        //         color: Colors.amber,
                                        //         fontWeight: FontWeight.bold),
                                        //   ),
                                        // );
                                      }),
                                ),
                        ],
                      ),
                    );
            }),
      ),
    );
  }
}
