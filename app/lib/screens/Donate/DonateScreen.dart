import 'dart:math';

import 'package:flutter/material.dart';
import 'package:iskcon/constants/databaseService.dart';
import 'package:iskcon/constants/useMixPanel.dart';
import 'package:iskcon/widgets/DonationTile.dart';
import 'package:iskcon/widgets/customAppBar.dart';
import 'package:shimmer/shimmer.dart';

class DonateScreen extends StatefulWidget {
  const DonateScreen({super.key});

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  late bool isLoading;
  List list = [
    {
      'color1': Color.fromRGBO(230, 248, 255, 1),
      'color2': Color.fromRGBO(168, 231, 255, 1),
      'color3': Color.fromRGBO(44, 174, 226, 1),
    },
    {
      'color1': Color.fromRGBO(255, 246, 209, 1),
      'color2': Color.fromRGBO(253, 236, 167, 1),
      'color3': Color.fromRGBO(244, 177, 5, 1),
    },
    {
      'color1': Color.fromRGBO(222, 255, 235, 1),
      'color2': Color.fromRGBO(170, 252, 203, 1),
      'color3': Color.fromRGBO(31, 211, 104, 1),
    },
    {
      'color1': Color.fromRGBO(255, 240, 240, 1),
      'color2': Color.fromRGBO(232, 121, 121, 1),
      'color3': Color.fromRGBO(216, 26, 26, 1),
    },
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
    var headingData =
        'Welcome to ISKCON Punjabi Bagh- the abode of Sri Sri Radha Radhikaraman & Sri Sri Krishna Balaram established under the shelter and instruction of our founder Acharya: His Divine Grace A.C Bhaktivedanta Swami Prabhupada.We believe that the act of charity is deeper than just a financial transaction. It’s a sacred offering to the divine, a contribution to greater cause and investment in spiritual growth. It deepens one’s attachment to Krishna,  supports the temple and serves the community. The fruits of charity to Krishna and for spiritual cause never perishes. There are various options for donations. You can choose to donate towards a specific cause, such as temple construction, deity seva, or education programs, or make a general donation to support our temple\'s activities.';
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: CustomAppBar(title: "Donate".toUpperCase())),
        // AppBar(
        //   title: Text(
        //     "Donate".toUpperCase(),
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
        //   toolbarHeight: 46,
        //   automaticallyImplyLeading: false,
        // ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              child: Column(
                children: [
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Container(
                  //   height: size.height * 0.2,
                  //   width: double.infinity,
                  //   child: Image.asset(
                  //     'assets/images/donationBanner.jpg',
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      headingData,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  FutureBuilder(
                      future: DataBaseSerice().donationList(),
                      builder: (context, snapshot) {
                        return !snapshot.hasData == true
                            ? GridView.builder(
                                padding: EdgeInsets.only(top: 20),
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: 4,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.7),
                                itemBuilder: (context, index) {
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      color: Colors.white,
                                    ),
                                  );
                                })
                            : Container(
                                padding: EdgeInsets.only(bottom: 20),
                                child: GridView.builder(
                                  padding: EdgeInsets.only(top: 20),
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.docs.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    crossAxisCount: 2,
                                    childAspectRatio: 3 / 3.2,
                                  ),
                                  itemBuilder: ((context, index) {
                                    final data = snapshot.data.docs[index];
                                    Random random = Random();
                                    var newlist =
                                        random.nextInt(list.length - 1);
                                    return DonationTile(
                                      title: data['name'],
                                      color1: list[newlist]['color1'],
                                      color2: list[newlist]['color2'],
                                      color3: list[newlist]['color3'],
                                      image: data.data()['resizedCoverImage'] !=
                                                  null &&
                                              data.data()['resizedCoverImage']
                                                      ['thumb'] !=
                                                  null
                                          ? data['resizedCoverImage']['thumb']
                                          : data['coverImage'],
                                      id: data.id,
                                      loaderColor: list[newlist]['color3'],
                                    );
                                  }),
                                ),
                              );
                      }),

                  SizedBox(
                    height: size.height * 0.1,
                  ),
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: SizedBox(
                  //     width: 120,
                  //     child: TextButton.icon(
                  //         style: TextButton.styleFrom(
                  //             backgroundColor: Colors.amber,
                  //             shape: RoundedRectangleBorder(
                  //                 borderRadius: BorderRadius.circular(20))),
                  //         onPressed: () {
                  //           Navigator.push(
                  //               context,
                  //               CupertinoPageRoute(
                  //                   builder: (context) => WebViews(
                  //                       // title: liveTitle!,
                  //                       // id: docid,
                  //                       // image: coverImage,
                  //                       )));
                  //         },
                  //         icon: Icon(
                  //           Icons.account_balance_wallet,
                  //           color: Colors.white,
                  //         ),
                  //         label: Text(
                  //           'DONATE',
                  //           style: TextStyle(color: Colors.white),
                  //         )),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ));
  }
}
