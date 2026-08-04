import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iskcon/constants/databaseService.dart';
import 'package:iskcon/screens/Videos/videoPlayer.dart';
import 'package:iskcon/widgets/VideosScreenTile.dart';
import 'package:iskcon/widgets/customAppBar.dart';
import 'package:shimmer/shimmer.dart';

class VideoLists extends StatefulWidget {
  final String id;
  final String title;
  const VideoLists({
    super.key,
    required this.title,
    required this.id,
  });

  @override
  State<VideoLists> createState() => _VideoListsState();
}

class _VideoListsState extends State<VideoLists> {
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
      appBar:
      PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: CustomAppBar(title:  widget.title)),
      //  AppBar(
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
        child: StreamBuilder(
            stream: DataBaseSerice().getCategoryList('Videos', widget.id),
            builder: (context, AsyncSnapshot snapshot) {
              return !snapshot.hasData
                  ? ListView.builder(
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
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                          margin: EdgeInsets.only(top: 20),
                          width: double.infinity,
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: ((context, index) {
                              var data = snapshot.data.docs[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => MyVideoPlayer(
                                              data: data,
                                              topTitle: widget.title,
                                              videoLink: data['url'])));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: VideosScreenTile(
                                    data: data,
                                    type: 'video',
                                    screen: screen,
                                    bgImageUrl:
                                        data.data()['resizedCoverImage'] == ''
                                            ? data['resizedCoverImage']['thumb']
                                            : data['coverImage'],
                                    // transparentBg: list[0]['transparentBg'],
                                    title: data['title'],
                                    imgPath: list[0]['imgPath'],
                                  ),
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
