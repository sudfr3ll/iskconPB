// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iskcon/constants/useMixPanel.dart';
import 'package:iskcon/screens/Blogs/BlogView.dart';
import 'package:iskcon/screens/Blogs/categoryL1.dart';
import 'package:iskcon/screens/Festivals/FestivalList.dart';
import 'package:iskcon/screens/News/NewsTab.dart';
import 'package:iskcon/screens/Quotes/QuotesScreen.dart';
import 'package:iskcon/screens/Subscription/step1.dart';
import 'package:iskcon/screens/UpcomingEvents/eventTab.dart';
import 'package:iskcon/screens/Videos/categoryL1.dart';
import 'package:iskcon/screens/audio/categoryL1.dart';
import 'package:iskcon/screens/pictures/categoryL1.dart';
import 'package:iskcon/widgets/DisplayTile.dart';

class FeaturedTiles extends StatefulWidget {
  final bool isHorizontal;
  final bool isGrid;
  const FeaturedTiles({
    this.isHorizontal = false,
    this.isGrid = true,
    super.key,
  });

  @override
  State<FeaturedTiles> createState() => _FeaturedTilesState();
}

class _FeaturedTilesState extends State<FeaturedTiles> {
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
      'title': 'vaisnava calendar',
      "icon": 'assets/svg/007-diwali.svg',
      'image': 'assets/features1/VaisnavaCalendar.png'
    },
    {
      'title': 'blogs',
      "icon": 'assets/svg/008-eye.svg',
      'image': 'assets/images/isckon_0003_daily_darshan.jpg'
    },
    {
      'title': 'Spiritual Books',
      "icon": 'assets/svg/quran2.svg',
      'image': 'assets/features1/SpiritualBoks.png'
    },
    // {
    //   'title': 'श्रीमद् भागवतम',
    //   "icon": 'assets/svg/bhagavad-gita1.svg',
    //   'image': 'assets/features1/HindisrimadBhagavtam.png'
    // },
    {
      'title': 'temple news',
      "icon": 'assets/svg/009-newspaper.svg',
      'image': 'assets/images/isckon_0001_news.jpg'
    },
    {
      'title': 'BTG MAGAZINE',
      "icon": 'assets/svg/subscribe.svg',
      'image': 'assets/images/2-1.png'
    },
  ];

  Future<void> sendTracking({title}) async {
    await UseMixPanel().sendTracking(event: "Click on $title in home");
  }

  void handleRouting(int index) async {
    await sendTracking(title: list[index]['title']);
    switch (index) {
      // case 0:
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => DailyDarshan(
      //               title: list[index]['title'],
      //             )),
      //   );

      // break;
      case 0:
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => PicturesCategoryL1(
                      title: list[index]['title'].toString().toUpperCase(),
                    )));

        break;
      case 1:
        Navigator.push(context,
            CupertinoPageRoute(builder: (context) => VideoCategory1()));

        break;
      case 2:
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => AudioCategoryL1(
                      title: list[index]['title'].toString().toUpperCase(),
                    )));

        break;
      case 3:
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => EventTab(
                      title: list[index]['title'].toString().toUpperCase(),
                    )));

        break;
      case 4:
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => QuotesScreen(),
          ),
        );

        break;
      case 5:
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => FestivalList(
              title: list[index]['title'].toString().toUpperCase(),
            ),
          ),
        );

        break;
      case 6:
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => BlogsCategoryL1(
                      title: list[index]['title'].toString().toUpperCase(),
                    )));

        break;
      case 7:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlogView(
              title: list[index]['title'].toString().toUpperCase(),
              url: 'https://vedabase.io/en/',
            ),
          ),
        );

        break;

      case 8:
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => NewsTab(
                      title: list[index]['title'].toString().toUpperCase(),
                    )));
        break;
      // case 9:
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => BlogView(
      //         title: list[index]['title'].toString().toUpperCase(),
      //         url: 'https://bhagavatam.in/#gsc.tab=0',
      //       ),
      //     ),
      //   );

      //   break;
      case 9:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubscriptionStep1(
              title: list[index]['title'].toString().toUpperCase(),
            ),
          ),
        );
        break;
      default:
        null;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      scrollDirection: widget.isHorizontal ? Axis.horizontal : Axis.vertical,
      padding: EdgeInsets.only(top: widget.isHorizontal ? 0 : 20),
      physics: widget.isHorizontal ? null : NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: list.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        crossAxisCount: widget.isHorizontal ? 1 : 2,
        childAspectRatio: widget.isHorizontal ? 0.8 : 1.6,
      ),
      itemBuilder: ((context, index) {
        if (widget.isGrid == false) {
          return InkWell(
            onTap: () => handleRouting(index),
            child: DisplayTile(
              tileIcon: list[index]['icon'],
              isTopLeftCurved: true,
              title: list[index]['title'].toString().toUpperCase(),
              imgUrl: list[index]['image'],
            ),
          );
        }
        if (index % 2 == 0) {
          return InkWell(
            onTap: () => handleRouting(index),
            child: DisplayTile(
              tileIcon: list[index]['icon'],
              isTopLeftCurved: true,
              title: list[index]['title'].toString().toUpperCase(),
              imgUrl: list[index]['image'],
            ),
          );
        }
        return InkWell(
          onTap: () => handleRouting(index),
          child: DisplayTile(
              tileIcon: list[index]['icon'],
              isTopLeftCurved: false,
              isTopRightCurved: true,
              title: list[index]['title'].toString().toUpperCase(),
              imgUrl: list[index]['image']),
        );
      }),
    );
  }
}
