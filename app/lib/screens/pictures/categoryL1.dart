import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iskcon/constants/databaseService.dart';
import 'package:iskcon/constants/useMixPanel.dart';
import 'package:iskcon/screens/pictures/categoryL2.dart';
import 'package:iskcon/screens/pictures/pictureList.dart';
import 'package:iskcon/widgets/customAppBar.dart';
import 'package:shimmer/shimmer.dart';

class PicturesCategoryL1 extends StatefulWidget {
  final String? title;
  const PicturesCategoryL1({super.key, this.title});

  @override
  State<PicturesCategoryL1> createState() => _PicturesCategoryL1State();
}

class _PicturesCategoryL1State extends State<PicturesCategoryL1> {
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
      'title': 'INITIATIONCEREMONY',
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

  Future<void> sendTracking({title}) async {
    await UseMixPanel().sendTracking(
        event: "Clicked on $title in Pictures (Category level 1) in Home");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: CustomAppBar(title: widget.title!)),
      //  AppBar(
      //   toolbarHeight: 46,
      //   title: Text(
      //     widget.title!,
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
      body: FutureBuilder(
          future: DataBaseSerice().categoryL1('pictures'),
          builder: (BuildContext context, snapshot) {
            return !snapshot.hasData
                ? Container(
                    margin: EdgeInsets.all(16.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: 6,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.9,
                        crossAxisSpacing: 20.0,
                        mainAxisSpacing: 20.0,
                        crossAxisCount: 2,
                      ),
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
                    ? Center(
                        child: Text('No Data Found'),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          // margin: EdgeInsets.all(16.0),
                          child: GridView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: snapshot.data.docs.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio:
                                  MediaQuery.of(context).size.width / 370,
                              crossAxisSpacing: 20.0,
                              mainAxisSpacing: 15.0,
                              crossAxisCount: 2,
                            ),
                            itemBuilder: (context, index) {
                              var data = snapshot.data.docs[index];
                              return InkWell(
                                  onTap: ()async {
                                    await sendTracking(title:data['name'] );
                                    data.data()['isSubCategory'] == true
                                        ? Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    PicturesCategoryL2(
                                                      title: data['name'],
                                                      id: data.id,
                                                    )))
                                        : Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    PictureList(
                                                      title: data['name'],
                                                      id: data.id,
                                                      description:
                                                          data['description'],
                                                    )));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(17, 112, 114, 1),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight:
                                                      Radius.circular(10)),
                                              child: Image.network(
                                                data.data()['resizedCoverImage'] !=
                                                            null &&
                                                        data.data()['resizedCoverImage']
                                                                ['thumb'] !=
                                                            null
                                                    ? data['resizedCoverImage']
                                                        ['thumb']
                                                    : data['coverImage'],
                                                fit: BoxFit.cover,
                                                height: 120,
                                                width: size.width * 0.5,
                                                loadingBuilder:
                                                    (BuildContext context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                  if (loadingProgress == null) {
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
                                              ),
                                            ),
                                            // Align(
                                            //     alignment: Alignment.topRight,
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
                                            //               builder: (context) =>
                                            //                   Padding(
                                            //                     padding: const EdgeInsets
                                            //                             .symmetric(
                                            //                         horizontal:
                                            //                             8.0),
                                            //                     child:
                                            //                         ShowDescription(
                                            //                       data: data,
                                            //                       description: data[
                                            //                           'description'],
                                            //                       image: data.data()['resizedCoverImage'] !=
                                            //                                   null &&
                                            //                               data.data()['resizedCoverImage']['thumb'] !=
                                            //                                   null
                                            //                           ? data['resizedCoverImage']
                                            //                               [
                                            //                               'thumb']
                                            //                           : data[
                                            //                               'coverImage'],
                                            //                       title: data[
                                            //                           'name'],
                                            //                     ),
                                            //                   ));
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Center(
                                              child: Text(
                                                data['name'],
                                                maxLines: 2,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
                                                textAlign: TextAlign.center,
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  //  Container(
                                  //   decoration: BoxDecoration(
                                  //       color: Colors.amber,
                                  //       borderRadius: BorderRadius.circular(10)),
                                  //   child: Column(
                                  //     children: [
                                  //       Stack(
                                  //         children: [
                                  //           Container(
                                  //             child: ClipRRect(
                                  //               borderRadius: BorderRadius.circular(
                                  //                   10), // Image border
                                  //               child: Image.network(
                                  //                 data.data()['resizedCoverImage'] !=
                                  //                             null &&
                                  //                         data.data()['resizedCoverImage']
                                  //                                 ['thumb'] !=
                                  //                             null
                                  //                     ? data['resizedCoverImage']
                                  //                         ['thumb']
                                  //                     : data['coverImage'],
                                  //                 fit: BoxFit.cover,
                                  //                 height: 120,
                                  //                 width: size.width * 0.5,
                                  //                 loadingBuilder:
                                  //                     (BuildContext context,
                                  //                         Widget child,
                                  //                         ImageChunkEvent?
                                  //                             loadingProgress) {
                                  //                   if (loadingProgress == null)
                                  //                     return child;
                                  //                   return Center(
                                  //                     child:
                                  //                         CircularProgressIndicator(
                                  //                       value: loadingProgress
                                  //                                   .expectedTotalBytes !=
                                  //                               null
                                  //                           ? loadingProgress
                                  //                                   .cumulativeBytesLoaded /
                                  //                               loadingProgress
                                  //                                   .expectedTotalBytes!
                                  //                           : null,
                                  //                     ),
                                  //                   );
                                  //                 },
                                  //               ),
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //       SizedBox(
                                  //         height: 10,
                                  //       ),
                                  //       Text(
                                  //         data.data()['name'],
                                  //         style: TextStyle(color: Colors.white),
                                  //         maxLines: 2,
                                  //         textAlign: TextAlign.center,
                                  //       )
                                  //     ],
                                  //   ),
                                  // ),

                                  );
                            },
                          ),
                        ),
                      );
          }),
    );
  }
}
