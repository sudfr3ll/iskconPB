import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iskcon/constants/databaseService.dart';
import 'package:iskcon/screens/Blogs/blogList.dart';
import 'package:iskcon/widgets/VideosScreenTile.dart';
import 'package:iskcon/widgets/customAppBar.dart';
import 'package:shimmer/shimmer.dart';

class BlogsCategoryL2 extends StatefulWidget {
  final String title;
  final String id;
  const BlogsCategoryL2({super.key, required this.title, required this.id});

  @override
  State<BlogsCategoryL2> createState() => _BlogsCategoryL2State();
}

class _BlogsCategoryL2State extends State<BlogsCategoryL2> {
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: CustomAppBar(title: widget.title)),
      // AppBar(
      //   centerTitle: true,
      //   title: Text(widget.title),
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
      body: FutureBuilder(
          future: DataBaseSerice().categoryL2(widget.id, 'blogs'),
          builder: (BuildContext context, snapshot) {
            return !snapshot.hasData
                ? Container(
                    margin: EdgeInsets.all(16.0),
                    child: ListView.builder(
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
                        }))
                : snapshot.data.docs.length == 0
                    ? Center(
                        child: Text('No Data Found'),
                      )
                    : Container(
                        margin: EdgeInsets.all(16.0),
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            var data = snapshot.data.docs[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => BlogList(
                                                title: data['title'],
                                                id: data.id,
                                              )));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: VideosScreenTile(
                                    type: 'blog',
                                    data: data,
                                    screen: screen,
                                    bgImageUrl:
                                        data.data()['resizedCoverImage'] !=
                                                    null &&
                                                data.data()['resizedCoverImage']
                                                        ['thumb'] !=
                                                    null
                                            ? data['resizedCoverImage']['thumb']
                                            : data['coverImage'],
                                    // transparentBg: list[0]['transparentBg'],
                                    title: data['name'],
                                    // imgPath: list[0]['imgPath'],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
          }),
    );
  }
}
