// ignore_for_file: sort_child_properties_last

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:iskcon/screens/Blogs/BlogView.dart';
import 'package:iskcon/screens/Donate/donate_by_paytm.dart';
import 'package:iskcon/widgets/customAppBar.dart';

class AboutEvent extends StatefulWidget {
  final String title;
  final String coverImage;
  final dynamic data;
  final dynamic eventLink;
  const AboutEvent(
      {super.key,
      required this.title,
      this.data,
      required this.coverImage,
      this.eventLink});

  @override
  State<AboutEvent> createState() => _AboutEventState();
}

class _AboutEventState extends State<AboutEvent> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: CustomAppBar(title: 'EVENTS')),
      // appBar: AppBar(
      //   title: Text(
      //     'EVENTS',
      //     style: TextStyle(fontSize: 15),
      //   ),
      //   centerTitle: true,
      //   toolbarHeight: 46,
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
      // ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageSlideshow(
                  width: double.infinity,
                  height: size.height * 0.3,
                  initialPage: 0,
                  indicatorColor: Color(0xff9C5AB1),
                  indicatorBackgroundColor: Colors.grey,
                  children: [
                    Image.network(
                      widget.data['coverImage'],
                      fit: BoxFit.cover,
                    ),
                  ],
                  onPageChanged: (value) {
                    print('Page changed: $value');
                  },
                  autoPlayInterval: 3000,
                  isLoop: false,
                ),
                SizedBox(
                  height: 10,
                ),
                // Container(
                //   height: size.height * 0.3,
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10),
                //       color: Colors.amber,
                //       image: DecorationImage(
                //           fit: BoxFit.cover,
                //           image: NetworkImage(
                //               'https://www.fabhotels.com/blog/wp-content/uploads/2019/06/ISKCON-Temples_600-1280x720.jpg'))),
                // ),
                Wrap(
                  children: [
                    // Text(
                    //   'Title :',
                    //   style: Theme.of(context).textTheme.headline6,
                    // ),
                    Text(widget.title.toUpperCase())
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Wrap(
                  children: [
                    // Text(
                    //   'Description',
                    //   style: Theme.of(context).textTheme.headline6,
                    // ),
                    Text(
                      widget.data['content'],
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    // widget.data['donationAllowed'] == null ||
                    widget.data['donationAllowed'] == false
                        // widget.data['donationAllowed'] == null
                        ? SizedBox()
                        : Container(
                            width: 120,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(colors: [
                                  Color(0xff9C5AB1),
                                  Color(0xff9C5AB1),

                                  // Color.fromRGBO(192, 175, 233, 1),
                                  // Color.fromRGBO(119, 97, 172, 1),
                                ])),
                            child: TextButton.icon(
                                style: TextButton.styleFrom(
                                    // backgroundColor: Colors.amber,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => DonateByPaytm(
                                                donId: widget.data.id,
                                                donName: widget.title,
                                              )));
                                  // Navigator.push(
                                  //     context,
                                  //     CupertinoPageRoute(
                                  //         builder: (context) => DonateAmount(
                                  //               title: widget.title,
                                  //               image:
                                  //                   widget.data['coverImage'],
                                  //             )));
                                },
                                icon: Icon(
                                  Icons.account_balance_wallet,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  'DONATE',
                                  style: TextStyle(color: Colors.white),
                                )),
                          ),
                    SizedBox(
                      width: 4,
                    ),
                    widget.data['eventLink'] == '' ||
                            widget.data['eventLink'] == ' ' ||
                            widget.data['eventLink'] == null ||
                            widget.data['eventLink'] == null
                        ? SizedBox()
                        : Container(
                            width: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xff9C5AB1), Color(0xff9C5AB1)
                                  // Color.fromRGBO(192, 175, 233, 1),
                                  // Color.fromRGBO(119, 97, 172, 1),
                                ],
                              ),
                            ),
                            child: TextButton.icon(
                                style: TextButton.styleFrom(
                                    // backgroundColor: Colors.amber,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => BlogView(
                                                title:
                                                    widget.title.toUpperCase(),
                                                url: widget.data['eventLink'],
                                              )));
                                },
                                icon: Icon(
                                  Icons.more,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  'Know More',
                                  style: TextStyle(color: Colors.white),
                                )),
                          )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
