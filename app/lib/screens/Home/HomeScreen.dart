// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iskcon/constants/databaseService.dart';
import 'package:iskcon/constants/provider.dart';
import 'package:iskcon/screens/Live/videoPlayer.dart';
import 'package:iskcon/widgets/FeaturedTiles.dart';
import 'package:iskcon/widgets/audioHorizontalWidget.dart';
import 'package:iskcon/widgets/horizontalDisplayTile.dart';
import 'package:iskcon/widgets/searchPage.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  dynamic data;
  var youtubedata;
  var status;
  String? thumbnail;
  List<dynamic> newdata = [];
  bool active = false;
  bool imageLoading = false;

  Future<void> getYoutubeData() async {
    // Timer(Duration(seconds: 3), () {
    await Provider.of<AppState>(context, listen: false).getLiveDetails();
    // });

    //  await ApiConstant().youtubeLiveApi();
    // print('Error is : $youtubedata');
    // print(youtubedata.body);
    // setState(() {
    //   status = youtubedata.statusCode;
    // });
    // youtubedata.statusCode != 200
    //     ? Provider.of<AppState>(context, listen: false).getLiveDetails()
    //     : youtubedata.response;
  }

  Future<void> getLiveStatus() async {
    await FirebaseFirestore.instance
        .collection('Live')
        .doc('Darshan')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      active = documentSnapshot.get('active');
    }).whenComplete(() => imageLoading = true);
  }

  Future getHomePage() async {
    Timer(Duration(seconds: 3), () async {
      var typedata = await DataBaseSerice().getPages();
      setState(() {
        newdata = typedata;
      });
      print(' Pages are : $newdata');
    });
  }

  @override
  void initState() {
    Provider.of<AppState>(context, listen: false).callFunction();
    // getYoutubeData();
    getLiveStatus();
    Timer(Duration(seconds: 3), () {
      print(
          'Init Status is : ${Provider.of<AppState>(context, listen: false).active}');
    });
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..repeat(reverse: true);
    // getHomePage();
    super.initState();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    var provider = Provider.of<AppState>(
      context,
    );
    print('Status is : ${provider.active}');
    print('Video Id is : ${provider.ytUrl}');
    return Scaffold(
      body: SingleChildScrollView(
        // physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: mediaQuery.height * 0.3,
              child: Stack(
                children: [
                  Container(
                    height: mediaQuery.height * 0.27,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(50)),
                      image: DecorationImage(
                        image: AssetImage("assets/images/homeBanner.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    // color: Colors.purple.shade700.withOpacity(0.9),
                    child: Container(
                      decoration: BoxDecoration(
                        // gradient: LinearGradient(
                        //     begin: Alignment.topCenter,
                        //     end: Alignment.bottomCenter,
                        //     colors: [
                        //       Color.fromRGBO(99, 70, 167, 1),
                        //       Color.fromRGBO(178, 166, 206, 0)
                        //     ]),
                        // color: Color.fromRGBO(116, 14, 186, 0.9),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Container(
                                //   margin: EdgeInsets.only(top: 15),
                                //   decoration: BoxDecoration(
                                //     color: Colors.white,
                                //     shape: BoxShape.circle,
                                //     // image: DecorationImage(
                                //     //   alignment: Alignment.center,
                                //     //     // colorFilter: ColorFilter.mode(Colors.black, BlendMode.clear),
                                //     //     image: AssetImage('assets/images/logo1.png')),
                                //   ),
                                //   height: mediaQuery.height * 0.15,
                                //   width: mediaQuery.width * 0.15,
                                //   child: Center(
                                //       child: Image.asset(
                                //     'assets/images/logo1.png',
                                //     height: 50,
                                //   )),
                                // ),
                                Spacer(),
                                Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 30),
                                      height: mediaQuery.height * 0.14,
                                      width: mediaQuery.width * 0.14,
                                      // decoration: BoxDecoration(
                                      //     image: DecorationImage(
                                      //         fit: BoxFit.fitWidth,
                                      //         image:
                                      //             AssetImage('assets/images/10.jpg')),
                                      //     shape: BoxShape.circle,
                                      //     color: Colors.green),
                                      // child: Image.asset('assets/images/logo.png', scale: 1.7),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Align(
                          //   alignment: Alignment.bottomLeft,
                          //   child: InkWell(
                          //     onTap: () {
                          //       Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //               builder: (context) => SerachPage()));
                          //     },
                          //     child: Container(
                          //       alignment: Alignment.bottomLeft,
                          //       height: mediaQuery.height * 0.0855,
                          //       margin: EdgeInsets.only(left: 20),
                          //       padding: EdgeInsets.only(bottom: 0),
                          //       child: TextFormField(
                          //         enabled: false,
                          //         cursorColor: Colors.purple,
                          //         decoration: InputDecoration(
                          //           contentPadding: EdgeInsets.all(12.0),
                          //           hintText: "Search",
                          //           focusColor: Colors.green,
                          //           filled: true,
                          //           fillColor: Colors.white,
                          //           prefixIcon: Icon(
                          //             Icons.search,
                          //             size: 20,
                          //             color: Colors.black26,
                          //           ),
                          //           focusedBorder: OutlineInputBorder(
                          //               borderRadius: BorderRadius.only(
                          //                 topLeft: Radius.circular(50),
                          //                 bottomLeft: Radius.circular(50),
                          //               ),
                          //               borderSide:
                          //                   BorderSide(color: Colors.black26)),
                          //           border: OutlineInputBorder(
                          //             borderSide: BorderSide(color: Colors.black26),
                          //             borderRadius: BorderRadius.only(
                          //               topLeft: Radius.circular(50),
                          //               bottomLeft: Radius.circular(50),
                          //             ),
                          //           ),
                          //           disabledBorder: OutlineInputBorder(
                          //             borderSide: BorderSide(color: Colors.black26),
                          //             borderRadius: BorderRadius.only(
                          //               topLeft: Radius.circular(50),
                          //               bottomLeft: Radius.circular(50),
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SerachPage()));
                      },
                      child: Container(
                        // alignment: Alignment.bottomLeft,
                        height: mediaQuery.height * 0.0855,
                        margin: EdgeInsets.only(left: 20, top: 10),
                        padding: EdgeInsets.only(bottom: 0),
                        child: TextFormField(
                          enabled: false,
                          cursorColor: Colors.purple,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(12.0),
                            hintText: "Search",
                            focusColor: Colors.green,
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(
                              Icons.search,
                              size: 20,
                              color: Colors.black26,
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  bottomLeft: Radius.circular(50),
                                ),
                                borderSide: BorderSide(color: Colors.black26)),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black26),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                bottomLeft: Radius.circular(50),
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black26),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                bottomLeft: Radius.circular(50),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    active == false ||
                            (provider.ytUrl == '')
                        ? SizedBox()
                        : Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Live Darshan',
                                  style: TextStyle(
                                    fontSize: mediaQuery.width * 0.049,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                // IconButton(
                                //   icon: Icon(
                                //     provider.showDarshan
                                //         ? Icons.video_call
                                //         : Icons.image,
                                //   ),
                                //   onPressed: () {
                                //     provider.showDarshanPic();
                                //   },
                                // )
                              ],
                            ),
                          ),
                    imageLoading == false
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: mediaQuery.height * 0.2,
                              width: mediaQuery.width,
                              margin: EdgeInsets.only(
                                  top: mediaQuery.height * 0.02),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                              ),
                            ),
                          )
                        : active == false ||
                                (provider.ytUrl == '')
                            ? SizedBox()
                            : InkWell(
                                onTap: provider.showDarshan
                                    ? () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Dialog(
                                              child: Image.network(
                                                  provider.darshanPic!),
                                            );
                                          },
                                        );
                                      }
                                    : () {
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    VideoPlayer(
                                                      youtubeId: provider.ytUrl,
                                                    )));
                                      },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: mediaQuery.height * 0.02),
                                  child: Container(
                                      height: mediaQuery.height * 0.2,
                                      width: mediaQuery.width,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          onError: ((exception, stackTrace) {
                                            setState(() {
                                              provider.active = false;
                                            });
                                          }),
                                          fit: BoxFit.cover,
                                          image: NetworkImage(provider
                                                  .showDarshan
                                              ? provider.darshanPic.toString()
                                              : provider.coverImage.toString()),
                                        ),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          provider.showDarshan
                                              ? Container()
                                              : Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                        top: mediaQuery.height *
                                                            0.01,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(5),
                                                        ),
                                                      ),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          FadeTransition(
                                                            opacity:
                                                                _animationController!,
                                                            child: Container(
                                                              height: 6,
                                                              width: 6,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    Colors.red,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          100),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            'Live',
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                  ],
                                                ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          provider.showDarshan
                                              ? Container()
                                              : Align(
                                                  alignment: Alignment.center,
                                                  child: Image.asset(
                                                    'assets/socialmedia/youtubeicon.png',
                                                    height: 50,
                                                  ),
                                                )
                                        ],
                                      )),
                                ),
                              ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 20),
                      child: Text(
                        'Features',
                        style: TextStyle(
                          fontSize: mediaQuery.width * 0.049,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    FeaturedTiles(),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      child: FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('Pages')
                              .doc('Homepage')
                              .get(),
                          builder: (context, AsyncSnapshot snapshot) {
                            return !snapshot.hasData
                                ? SizedBox()
                                : Column(
                                    children: snapshot.data['sections']
                                        .map<Widget>((e) => Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: double.infinity,
                                                  // margin:
                                                  //     EdgeInsets.only(top: 8),
                                                  child: Text(
                                                    'Temple ${e['type']}',
                                                    style: TextStyle(
                                                      fontSize:
                                                          mediaQuery.width *
                                                              0.049,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    child:
                                                        HorizontalDisplayTime(
                                                      type: e['type'],
                                                    )),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ))
                                        .toList(),
                                  );
                          }),
                    ),
                    FutureBuilder(
                        future: DataBaseSerice().getSettings('general'),
                        builder: (context, snapshtos) {
                          return !snapshtos.hasData
                              ? SizedBox()
                              : snapshtos.data['homePage']['showAudios'] ==
                                      false
                                  ? SizedBox()
                                  : FutureBuilder(
                                      future:
                                          DataBaseSerice().categoryL1('audios'),
                                      builder: ((context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return SizedBox();
                                        } else {
                                          return Column(
                                            children: [
                                              SizedBox(
                                                width: double.infinity,
                                                // margin:
                                                //     EdgeInsets.only(top: 20),
                                                child: Text(
                                                  'Temple Audios',
                                                  style: TextStyle(
                                                    fontSize: mediaQuery.width *
                                                        0.049,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              SingleChildScrollView(
                                                physics:
                                                    BouncingScrollPhysics(),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  children: snapshot.data.docs
                                                      .map<Widget>((e) =>
                                                          audioWidget(
                                                              e, context))
                                                      .toList(),
                                                ),
                                              )
                                            ],
                                          );
                                        }
                                      }),
                                    );
                        }),

                    // ListView.builder(
                    //     physics: NeverScrollableScrollPhysics(),
                    //     // scrollDirection: Axis.vertical,
                    //     itemCount: newdata.length,
                    //     shrinkWrap: true,
                    //     itemBuilder: (context, index) {
                    //       var data = newdata[index];
                    //       return SizedBox(
                    //           height: MediaQuery.of(context).size.height * 0.3,
                    //           child: HorizontalDisplayTime(
                    //             type: data['type'],
                    //           ));
                    //     }),
                    SizedBox(
                      height: mediaQuery.height * 0.15,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
