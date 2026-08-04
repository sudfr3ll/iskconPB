// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iskcon/constants/databaseService.dart';
import 'package:iskcon/constants/useMixPanel.dart';
import 'package:iskcon/screens/Videos/categoryL2.dart';
import 'package:iskcon/screens/Videos/videosList.dart';
import 'package:iskcon/widgets/customAppBar.dart';
import 'package:shimmer/shimmer.dart';

class VideoCategory1 extends StatefulWidget {
  const VideoCategory1({super.key});

  @override
  State<VideoCategory1> createState() => _VideoCategory1State();
}

class _VideoCategory1State extends State<VideoCategory1> {
  late bool isLoading;

  @override
  void initState() {
    isLoading = true;
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  Future<void> sendTracking({title}) async {
    await UseMixPanel().sendTracking(
        event: "Clicked on $title in Videos (Category level 1) in Home");
  }

  @override
  Widget build(BuildContext context) {
    List list = [
      {
        'bgImage': 'https://iskconnews.org/media/images/2021/02-Feb/juhu2.png',
        'transparentBg': Color.fromARGB(180, 1, 172, 240),
        'imgPath': 'assets/svg/034-discussion.svg',
        'title': 'VARTALAAP'
      },
      {
        'bgImage':
            'https://bangaloretourism.in/images/v2/places-to-visit/iskcon-temple-bangalore/iskcon-temple-bangalore-bangalore-opening-time-closing-bangalore-tourism-cr-cariberry.jpg',
        'transparentBg': Color.fromARGB(180, 34, 57, 130),
        'imgPath': 'assets/svg/035-communication.svg',
        'title': 'JAPA TALKS'
      },
      {
        'bgImage': 'https://www.vina.cc/wp-content/uploads/2017/12/85.jpg',
        'transparentBg': Color.fromARGB(180, 242, 196, 6),
        'imgPath': 'assets/svg/036-conference.svg',
        'title': 'LECTURES'
      },
      {
        'bgImage':
            'https://cdn.tovp.org/wp-content/uploads/2013/01/tovp_drawing_slide-lg.jpg.webp',
        'transparentBg': Color.fromARGB(180, 239, 30, 30),
        'imgPath': 'assets/svg/037-guru.svg',
        'title': 'SRILA PRABHUPADA'
      },
    ];

    var screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: CustomAppBar(title: 'VIDEOS')),
      //     AppBar(
      //   toolbarHeight: 46,
      //   title: Text(
      //     'VIDEOS',
      //     style: TextStyle(fontSize: 15),
      //   ),
      //   actions: [
      //     Image.asset(
      //       'assets/images/logo.png',
      //       height: 40,
      //       width: 40,
      //     ),
      //     SizedBox(
      //       width: 10,
      //     )
      //   ],
      //   centerTitle: true,
      // ),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: DataBaseSerice().categoryL1('videos'),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Container(
                      margin: EdgeInsets.all(16.0),
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio:
                                MediaQuery.of(context).size.width / 370,
                            crossAxisSpacing: 20.0,
                            mainAxisSpacing: 15.0,
                            crossAxisCount: 2,
                          ),
                          shrinkWrap: true,
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                              ),
                            );
                          }),
                    )
                  : snapshot.data.docs.length == 0
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: Center(
                            child: Text('No Data Found'),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                              margin: EdgeInsets.only(top: 20),
                              width: double.infinity,
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio:
                                      MediaQuery.of(context).size.width / 390,
                                  crossAxisSpacing: 20.0,
                                  mainAxisSpacing: 15.0,
                                  crossAxisCount: 2,
                                ),
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: ((context, index) {
                                  var data = snapshot.data.docs[index];
                                  return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: InkWell(
                                        onTap: () async {
                                          await sendTracking(
                                              title: data['name']);
                                          data.data()['isSubCategory'] == true
                                              ? Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                      builder: (context) =>
                                                          VideoCategory2(
                                                              title:
                                                                  data['name'],
                                                              id: data.id)))
                                              : Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                      builder: (context) =>
                                                          VideoLists(
                                                              title:
                                                                  data['name'],
                                                              id: data.id)));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  17, 112, 114, 1),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Column(
                                            children: [
                                              Stack(
                                                children: [
                                                  Container(
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              topRight: Radius
                                                                  .circular(
                                                                      10)), // Image border
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
                                                            screen.width * 0.5,
                                                        loadingBuilder:
                                                            (BuildContext
                                                                    context,
                                                                Widget child,
                                                                ImageChunkEvent?
                                                                    loadingProgress) {
                                                          if (loadingProgress ==
                                                              null)
                                                            return child;
                                                          return SizedBox(
                                                            height: 120,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
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
                                                  ),
                                                  // Align(
                                                  //     alignment:
                                                  //         Alignment.topRight,
                                                  //     child: IconButton(
                                                  //         onPressed: () {
                                                  //           showModalBottomSheet(
                                                  //               shape:
                                                  //                   RoundedRectangleBorder(
                                                  //                 borderRadius: BorderRadius.only(
                                                  //                     topLeft: Radius
                                                  //                         .circular(
                                                  //                             20),
                                                  //                     topRight:
                                                  //                         Radius.circular(
                                                  //                             20)),
                                                  //               ),
                                                  //               enableDrag:
                                                  //                   true,
                                                  //               context:
                                                  //                   context,
                                                  //               builder:
                                                  //                   (context) =>
                                                  //                       Padding(
                                                  //                         padding:
                                                  //                             const EdgeInsets.symmetric(horizontal: 8.0),
                                                  //                         child: ShowDescription(
                                                  //                             data: data,
                                                  //                             description: data['description'],
                                                  //                             image: data.data()['resizedCoverImage'] != null && data.data()['resizedCoverImage']['thumb'] != null ? data['resizedCoverImage']['thumb'] : data['coverImage'],
                                                  //                             title: data['name']),
                                                  //                       ));
                                                  //         },
                                                  //         icon: Icon(
                                                  //           Icons.info_outline,
                                                  //           color: Colors.white,
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
                                                          color: Colors.white,
                                                          fontSize: 14),
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                      //   VideosScreenTile(
                                      //     screen: screen,
                                      //     bgImageUrl: data.data()[
                                      //                     'resizedCoverImage'] !=
                                      //                 null &&
                                      //             data.data()['resizedCoverImage']
                                      //                     ['thumb'] !=
                                      //                 null
                                      //         ? data['resizedCoverImage']['thumb']
                                      //         : data['coverImage'],
                                      //     // transparentBg: list[0]['transparentBg'],
                                      //     title: data['name'],
                                      //     imgPath: list[0]['imgPath'],
                                      //   ),
                                      // ),
                                      );
                                }),
                              )),
                        );
            }),
      ),
    );
  }
}
