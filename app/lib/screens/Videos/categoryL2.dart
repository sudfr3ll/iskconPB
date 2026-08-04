import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iskcon/constants/databaseService.dart';
import 'package:iskcon/screens/Videos/categoryL3.dart';
import 'package:iskcon/screens/Videos/videosList.dart';
import 'package:iskcon/widgets/customAppBar.dart';
import 'package:shimmer/shimmer.dart';

class VideoCategory2 extends StatefulWidget {
  final String id;
  final String title;
  const VideoCategory2({super.key, required this.id, required this.title});

  @override
  State<VideoCategory2> createState() => _VideoCategory2State();
}

class _VideoCategory2State extends State<VideoCategory2> {
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
          child: CustomAppBar(title:  widget.title)),
      
      // AppBar(
      //   toolbarHeight: 46,
      //   title: Text(
      //     widget.title,
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
            future: DataBaseSerice().categoryL2(widget.id, 'videos'),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Container(
                      margin: EdgeInsets.all(16.0),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio:
                              MediaQuery.of(context).size.width / 390,
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
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
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
                                      MediaQuery.of(context).size.width / 380,
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
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: InkWell(
                                      onTap: () {
                                        data.data()['isSubCategory'] == true
                                            ? Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: (context) =>
                                                        VideoCategory3(
                                                            title: data['name'],
                                                            id1: widget.id,
                                                            id2: data.id)))
                                            : Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: (context) =>
                                                        VideoLists(
                                                            title: data['name'],
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
                                                    borderRadius: BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(10),
                                                        topRight: Radius.circular(
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
                                                          : data['coverImage'],
                                                      loadingBuilder: (BuildContext
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
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.5,
                                                          child: Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                              color:
                                                                  Colors.white,
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
                                                      fit: BoxFit.cover,
                                                      height: 120,
                                                      width: screen.width * 0.5,
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
                                                //                     topRight: Radius
                                                //                         .circular(
                                                //                             20)),
                                                //               ),
                                                //               enableDrag: true,
                                                //               context: context,
                                                //               builder:
                                                //                   (context) =>
                                                //                       Padding(
                                                //                         padding:
                                                //                             const EdgeInsets.symmetric(horizontal: 8.0),
                                                //                         child: ShowDescription(
                                                //                             data:
                                                //                                 data,
                                                //                             description: data[
                                                //                                 'description'],
                                                //                             image: data.data()['resizedCoverImage'] != null && data.data()['resizedCoverImage']['thumb'] != null
                                                //                                 ? data['resizedCoverImage']['thumb']
                                                //                                 : data['coverImage'],
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
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Flexible(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Center(
                                                  child: Text(
                                                    data['name'],
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16),
                                                    textAlign: TextAlign.center,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      //  Padding(
                                      //   padding:
                                      //       const EdgeInsets.only(bottom: 20.0),
                                      //   child: VideosScreenTile(
                                      //     screen: screen,
                                      //     bgImageUrl:
                                      //        data.data()['resizedCoverImage'] !=
                                      //                       null &&
                                      //                   data.data()['resizedCoverImage']
                                      //                           ['thumb'] !=
                                      //                       null
                                      //               ? data['resizedCoverImage']
                                      //                   ['thumb']
                                      //               : data['coverImage'],
                                      //     // transparentBg: list[0]['transparentBg'],
                                      //     title: data['name'],
                                      //     imgPath: list[0]['imgPath'],
                                      //   ),
                                      // ),
                                    ),
                                  );
                                }),
                              )),
                        );
            }),
      ),
    );
  }
}
