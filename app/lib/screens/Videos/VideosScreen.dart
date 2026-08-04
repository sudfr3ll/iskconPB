import 'package:flutter/material.dart';
import 'package:iskcon/widgets/VideosScreenTile.dart';
import 'package:shimmer/shimmer.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({super.key});

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
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
    List data = [
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
          'VIDEOS',
          style: TextStyle(fontSize: 15),
        ),
        actions: [Image.asset('assets/images/logo2.png')],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
              margin: EdgeInsets.only(top: 20),
              width: double.infinity,
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: isLoading == true
                          ? Shimmer.fromColors(
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
                            )
                          : VideosScreenTile(
                            data: data,
                              screen: screen,
                              bgImageUrl: data[index]['bgImage'],
                              transparentBg: data[index]['transparentBg'],
                              title: data[index]['title'],
                              imgPath: data[index]['imgPath'],
                            ),
                    );
                  }))
              // Column(
              //   children: data.map((item,index) => {
              //     return Text('');
              //   }).toList(),
              //  [
              //   Stack(
              //     children: [
              //       Container(
              //         height: 180,
              //         width: double.infinity,
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.all(
              //             Radius.circular(20),
              //           ),
              //           image: DecorationImage(
              //             image: NetworkImage(
              //                 'https://iskconnews.org/media/images/2021/02-Feb/juhu2.png'),
              //             fit: BoxFit.cover,
              //           ),
              //           color: Colors.red,
              //         ),
              //       ),
              //       Positioned(
              //         child: Container(
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.only(
              //               topLeft: Radius.circular(20),
              //               topRight: Radius.circular(10),
              //               bottomLeft: Radius.circular(20),
              //               bottomRight: Radius.circular(80),
              //             ),
              //             // color: Color.fromRGBO(1, 172, 240, 0.8),
              //             color: Color.fromARGB(180, 1, 172, 240),
              //           ),
              //           height: 180,
              //           width: screen.width * 0.58,
              //           child: Center(
              //             child: Text('sac'),
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // ],
              ),
        ),
      ),
    );
  }
}
