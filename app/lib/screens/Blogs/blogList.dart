import 'package:flutter/material.dart';
import 'package:iskcon/constants/databaseService.dart';
import 'package:iskcon/screens/Blogs/BlogView.dart';
import 'package:iskcon/widgets/VideosScreenTile.dart';
import 'package:iskcon/widgets/customAppBar.dart';
import 'package:shimmer/shimmer.dart';

class BlogList extends StatefulWidget {
  final String title;
  final String id;
  const BlogList({super.key, required this.title, required this.id});

  @override
  State<BlogList> createState() => _BlogListState();
}

class _BlogListState extends State<BlogList> {
  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: CustomAppBar(title: widget.title)),
      // appBar: AppBar(
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
        physics: BouncingScrollPhysics(),
        child: StreamBuilder(
            stream: DataBaseSerice().getCategoryList('Blogs', widget.id),
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
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 20.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => BlogView(
                                                      title: data['title'],
                                                      url: data['url'],
                                                    )));
                                      },
                                      child: VideosScreenTile(
                                        type: 'blog',
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
                                        title: data['title'],
                                        // imgPath: list[0]['imgPath'],
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
