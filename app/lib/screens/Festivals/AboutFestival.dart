// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class AboutFestival extends StatelessWidget {
  final String title;
  final dynamic data;
  const AboutFestival({super.key, required this.title, this.data});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title.toUpperCase(),
          style: TextStyle(fontSize: 15),
        ),
        centerTitle: true,
        toolbarHeight: 46,
      ),
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
                  indicatorColor: Colors.amber,
                  indicatorBackgroundColor: Colors.grey,
                  children: [
                    Image.network(
                      data['coverImage'],
                      fit: BoxFit.cover,
                    ),
                  ],
                  onPageChanged: (value) {
                    print('Page changed: $value');
                  },
                  autoPlayInterval: 3000,
                  isLoop: true,
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
                Text(
                  data['content'],
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 20,
                ),
                // Text(
                //   'Deepotsava – Significance',
                //   textAlign: TextAlign.start,
                //   style: TextStyle(color: Color.fromRGBO(67, 96, 88, 1)),
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                // Text(
                //   'It is not possible to describe the glories of Kartika month. In this month devotees observe strict vows (Damodara Vrata) and worship Lord Damodara by offering a ghee lamp every day. It is said that by offering a lamp to Lord Hari in the month of Kartika one gets unlimited prosperity, beauty and wealth. All the sins committed in thousands and millions of births perish, and one attains the eternal spiritual world where there is no suffering.',
                //   textAlign: TextAlign.start,
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                // Text(
                //   'In this month, every day the temple is decorated with thousands of lamps. Light from hundreds of lamps placed before the altar spread transcendental radiance across the main temple hall, elevating the spirit of devotion. The grandeur with which the festivities are carried out captivates everyone’s realm of devotion.',
                //   textAlign: TextAlign.start,
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                // Text(
                //   'At 8:00 p.m., the altar is closed briefly followed by an announcement on Deepotsava Festival. The assembled devotees are informed about the significance of this festival. Following the announcement, the devotees start singing melodious kirtans and the altar opens. The glorious sight of Their Lordships Sri Radha Krishnachandra in the midst of smoke enthralls everyone',
                //   textAlign: TextAlign.start,
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
