import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iskcon/constants/databaseService.dart';
import 'package:iskcon/screens/Videos/videosList.dart';
import 'package:iskcon/widgets/VideosScreenTile.dart';
import 'package:shimmer/shimmer.dart';

class VideoCategory3 extends StatefulWidget {
  final String id1;
  final String id2;
  final String title;
  const VideoCategory3(
      {super.key, required this.title, required this.id1, required this.id2});

  @override
  State<VideoCategory3> createState() => _VideoCategory3State();
}

class _VideoCategory3State extends State<VideoCategory3> {
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
      appBar: AppBar(
        toolbarHeight: 46,
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 15),
        ),
        actions: [Image.asset('assets/images/logo2.png')],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future:
                DataBaseSerice().categoryL3(widget.id1, widget.id2, 'videos'),
            builder: (context, snapshot) {
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
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: ((context, index) {
                                  var data = snapshot.data.docs[index];
                                  return InkWell(
                                    onTap: () => Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) => VideoLists(
                                                title: data['name'],
                                                id: data.id))),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20.0),
                                      child: VideosScreenTile(
                                        data: data,
                                        screen: screen,
                                        bgImageUrl: data.data()[
                                                        'resizedCoverImage'] !=
                                                    null &&
                                                data.data()['resizedCoverImage']
                                                        ['thumb'] !=
                                                    null
                                            ? data['resizedCoverImage']['thumb']
                                            : data['coverImage'],
                                        // transparentBg: list[0]['transparentBg'],
                                        title: data['name'],
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
