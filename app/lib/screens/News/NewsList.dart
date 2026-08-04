// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iskcon/constants/databaseService.dart';
import 'package:iskcon/constants/useMixPanel.dart';
import 'package:iskcon/screens/News/AboutNews.dart';
import 'package:shimmer/shimmer.dart';

class NewsList extends StatefulWidget {
  const NewsList({super.key});

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  Future<void> sendTracking({title}) async {
    await UseMixPanel().sendTracking(
        event: "Clicked on $title in Temple News (Category level 1) in Home");
  }

  @override
  Widget build(BuildContext context) {
    final date = DateFormat.yMMMd('en_US');
    return FutureBuilder(
        future: DataBaseSerice().newsList(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 6,
                  itemBuilder: (context, builder) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: 50,
                            color: Colors.white,
                          )),
                    );
                  })
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data.docs[index];
                    return ListTile(
                      leading: Container(
                        width: 100,
                        alignment: Alignment.centerLeft,
                        child: Image.network(
                          data['images'][0]['thumb'],
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      onTap: () async {
                        await sendTracking(title: data['title']);
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => AboutNews(
                                      data: data,
                                      title: data['title']
                                          .toString()
                                          .toUpperCase(),
                                    )));
                      },
                      title: Text(data['title']),
                      subtitle: Text(
                        '${date.format(data['createdAt'].toDate())}',
                        style: Theme.of(context).textTheme.bodySmall!,
                      ),
                    );
                  });
        });
  }
}
