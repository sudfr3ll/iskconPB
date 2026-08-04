// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iskcon/constants/databaseService.dart';
import 'package:iskcon/constants/useMixPanel.dart';
import 'package:iskcon/screens/Blogs/BlogView.dart';
import 'package:iskcon/screens/News/AboutNews.dart';
import 'package:iskcon/screens/UpcomingEvents/aboutEvent.dart';
import 'package:iskcon/screens/Videos/videoPlayer.dart';
import 'package:iskcon/screens/pictures/pictureView.dart';
import 'package:shimmer/shimmer.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

class HorizontalDisplayTime extends StatefulWidget {
  final String? type;
  const HorizontalDisplayTime({super.key, this.type});

  @override
  State<HorizontalDisplayTime> createState() => _HorizontalDisplayTimeState();
}

class _HorizontalDisplayTimeState extends State<HorizontalDisplayTime> {
  List<dynamic> newdata = [];
  bool isLoading = false;

  List list = [
    {
      'title': 'pictures',
      "icon": 'assets/svg/004-picture.svg',
      'image': 'assets/images/isckon_0007_images.jpg'
    },
    {
      'title': 'videos',
      "icon": 'assets/svg/003-video-camera.svg',
      'image': 'assets/images/isckon_0006_videos.jpg'
    },
    {
      'title': 'audios',
      "icon": 'assets/svg/010-musical-note.svg',
      'image': 'assets/images/isckon_0002_audio.jpg'
    },
    {
      'title': 'events',
      "icon": 'assets/svg/005-calendars.svg',
      'image': 'assets/images/isckon_0005_event.jpg'
    },
    {
      'title': 'quotes of the day',
      "icon": 'assets/svg/030-quotation-mark.svg',
      'image': 'assets/images/isckon_0004_quote.jpg'
    },
    {
      'title': 'festivals',
      "icon": 'assets/svg/007-diwali.svg',
      'image': 'assets/images/isckon_0000_festival.jpg'
    },
    {
      'title': 'daily darshan',
      "icon": 'assets/svg/008-eye.svg',
      'image': 'assets/images/isckon_0003_daily_darshan.jpg'
    },
    {
      'title': 'news',
      "icon": 'assets/svg/009-newspaper.svg',
      'image': 'assets/images/isckon_0001_news.jpg'
    },
  ];

  Future getHomePage() async {
    Timer(Duration(seconds: 3), () async {
      var typedata = await DataBaseSerice().homesections(widget.type);
      setState(() {
        newdata = typedata;
      });
      setState(() {
        isLoading = true;
      });
      // for (int i = 0; i < newdata.length; i++) {
      //   widget.type == 'News'
      //       ? {
      //           print(newdata[i]['content']),
      //           print(newdata[i]['title']),
      //           print(newdata[i])
      //         }
      //       : null;
      // }
    });
  }

  @override
  void initState() {
    getHomePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var date = DateFormat.yMMMd('en_US');

    Future<void> sendTracking({type, title}) async {
      await UseMixPanel()
          .sendTracking(event: "Clicked on $title from Temple $type in home");
    }

    return newdata.isEmpty
        ? SizedBox()
        : !isLoading
            ? ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 250,
                          height: MediaQuery.of(context).size.height * 0.7,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                            ),
                          ),
                        ),
                      ),
                    ))
            : ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: newdata.length,
                itemBuilder: (context, index) {
                  var data = newdata[index];
                  return InkWell(
                    onTap: () async {
                      await sendTracking(
                          type: widget.type, title: data['title']);
                      widget.type == 'News'
                          ? Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => AboutNews(
                                      data: data, title: data['title'])))
                          : widget.type == 'Blogs'
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BlogView(
                                            title: data['title'],
                                            url: data['url'],
                                          )))
                              : widget.type == 'Events'
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AboutEvent(
                                          title: data['title'],
                                          data: data,
                                          coverImage: data['coverImage'],
                                          // donationAllowed:
                                          //     data['donationAllowed'],
                                        ),
                                      ),
                                    )
                                  : widget.type == 'Videos'
                                      ? Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) => MyVideoPlayer(
                                              data: data,
                                              topTitle: data['title'],
                                              videoLink: data['url'],
                                            ),
                                          ),
                                        )
                                      : widget.type == 'Pictures'
                                          ? Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      PictureViewList(
                                                        index: index,
                                                        data: newdata,
                                                        // title: data['name'],
                                                        // id: data.id,
                                                        // description: data[
                                                        //                 index]
                                                        //             .data()['description'] ==
                                                        //         null
                                                        //     ? ''
                                                        //     : data['description'],
                                                      )))
                                          : null;
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      width: MediaQuery.of(context).size.width * 0.65,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 232,
                                height: 132,
                                decoration: BoxDecoration(
                                  // color: Colors.amber,
                                  gradient: LinearGradient(colors: [
                                    Color.fromRGBO(178, 166, 206, 0),
                                    Color.fromRGBO(99, 70, 167, 1),
                                  ]),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    bottomRight: Radius.circular(25),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: .0),
                                child: Container(
                                  width: 230,
                                  height: 130,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      bottomRight: Radius.circular(25),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      bottomRight: Radius.circular(25),
                                    ),
                                    child: FancyShimmerImage(
                                      imageUrl: widget.type == 'News'
                                          ? data['images'][0]['thumb']
                                          : widget.type == 'Pictures'
                                              ? data['image']['thumb']
                                              : data['coverImage'] ?? '',
                                      boxFit: BoxFit.cover,
                                      errorWidget: SizedBox(
                                        width: 230,
                                        height: 130,
                                        child: Image.asset(
                                          'assets/images/defaultimg.jpg',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          Flexible(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                data['title'].toString().toUpperCase(),
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(date.format(data['createdAt'].toDate()),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodySmall),
                          ),
                        ],
                      ),
                    ),
                  );
                });
  }
}
