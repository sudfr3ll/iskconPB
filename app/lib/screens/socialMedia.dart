// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:iskcon/constants/databaseService.dart';
import 'package:iskcon/models/urlLauncher.dart';
import 'package:iskcon/widgets/customAppBar.dart';
import 'package:shimmer/shimmer.dart';

class SocialMedial extends StatelessWidget {
  const SocialMedial({super.key});

  @override
  Widget build(BuildContext context) {
    // Future launchUrl(url) async {
    //   UrlLaunchers(url);
    // }
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: CustomAppBar(title: 'SOCIAL MEDIA')),
      // appBar: AppBar(
      //   toolbarHeight: 46,
      //   title: Text(
      //     'SOCIAL MEDIA',
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
          future: DataBaseSerice().socialMedial(),
          builder: (context, snapshot) {
            var data = snapshot.data;
            var isData = snapshot.hasData;
            return Container(
              child: Column(
                children: [
                  !isData
                      ? Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: 100,
                            color: Colors.white,
                            child: ListTile(),
                          ),
                        )
                      : Container(
                          height: 100,
                          child: Center(
                            child: ListTile(
                              onTap: () => UrlLaunchers()
                                  .urlLaunch(data['youtube']['url']),
                              tileColor: Colors.red.shade50,
                              leading:
                                  Image.asset('assets/socialmedia/youtube.png'),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Follow us on Youtube'),
                                  Text(
                                    data['youtube']['followers'],
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                  !isData
                      ? Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: 100,
                            color: Colors.white,
                            child: ListTile(),
                          ),
                        )
                      : Container(
                          height: 100,
                          child: ListTile(
                            onTap: () => UrlLaunchers()
                                .urlLaunch(data['facebook']['url']),
                            tileColor: Colors.blue.shade50,
                            leading:
                                Image.asset('assets/socialmedia/facebook.png'),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Follow us on Facebook'),
                                Text(
                                  data['facebook']['followers'],
                                  style: TextStyle(color: Colors.blue),
                                ),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          ),
                        ),
                  !isData
                      ? Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: 100,
                            color: Colors.white,
                            child: ListTile(),
                          ),
                        )
                      : Container(
                          height: 100,
                          child: ListTile(
                            onTap: () => UrlLaunchers()
                                .urlLaunch(data['instagram']['url']),
                            tileColor: Colors.pink.shade50,
                            leading:
                                Image.asset('assets/socialmedia/instagram.png'),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Follow us on Instagram'),
                                Text(
                                  data['instagram']['followers'],
                                  style: TextStyle(color: Colors.pink),
                                ),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          ),
                        ),
                  !isData
                      ? Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: 100,
                            color: Colors.white,
                            child: ListTile(),
                          ),
                        )
                      : Container(
                          height: 100,
                          child: ListTile(
                            onTap: () => UrlLaunchers()
                                .urlLaunch(data['onWebsite']['url']),
                            tileColor: Colors.cyan.shade50,
                            leading: Image.asset('assets/socialmedia/www.png'),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Visit Our Website'),
                                Text(
                                  'https://www.iskconpunjabibagh.com/',
                                  style: TextStyle(color: Colors.cyan.shade400),
                                ),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            );
          }),
    );
  }
}
