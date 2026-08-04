import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iskcon/constants/databaseService.dart';
import 'package:iskcon/constants/useMixPanel.dart';
import 'package:iskcon/screens/Blogs/blogList.dart';
import 'package:iskcon/screens/Blogs/categoryL2.dart';
import 'package:iskcon/widgets/VideosScreenTile.dart';
import 'package:iskcon/widgets/customAppBar.dart';
import 'package:shimmer/shimmer.dart';

class BlogsCategoryL1 extends StatefulWidget {
  final String? title;
  const BlogsCategoryL1({super.key, this.title});

  @override
  State<BlogsCategoryL1> createState() => _BlogsCategoryL1State();
}

class _BlogsCategoryL1State extends State<BlogsCategoryL1> {
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
    {'title': 'INITIATIONCEREMONY', 'image': 'assets/pictures/Rectangle82.png'},
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
        event: "Clicked on $title in Blogs (Category level 1) in Home");
  }

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;

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
          future: DataBaseSerice().categoryL1('blogs'),
          builder: (BuildContext context, snapshot) {
            return !snapshot.hasData
                ? ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: 180,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      );
                    })
                : snapshot.data.docs.length == 0
                    ? Center(
                        child: Text('No Data Found'),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          // margin: EdgeInsets.all(16.0),
                          child: ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              var data = snapshot.data.docs[index];
                              return InkWell(
                                onTap: () async {
                                  await sendTracking(title: data['title']);
                                  data.data()['isSubCategory'] == true
                                      ? Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  BlogsCategoryL2(
                                                    title: data['title'],
                                                    id: data.id,
                                                  )))
                                      : Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) => BlogList(
                                                    title: data['title'],
                                                    id: data.id,
                                                    // id: data.id,
                                                    // description:
                                                    //     data['description'],
                                                  )));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: VideosScreenTile(
                                    type: 'blog',
                                    data: data,
                                    screen: screen,
                                    bgImageUrl:
                                        data.data()['resizedCoverImage'] !=
                                                    null &&
                                                data.data()['resizedCoverImage']
                                                        ['thumb'] !=
                                                    null
                                            ? data['resizedCoverImage']['thumb']
                                            : data['coverImage'],
                                    // transparentBg: list[0]['transparentBg'],
                                    title: data['name'],
                                    // imgPath: list[0]['imgPath'],
                                  ),
                                ),
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
