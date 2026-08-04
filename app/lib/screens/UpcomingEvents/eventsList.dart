// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iskcon/constants/databaseService.dart';
import 'package:iskcon/constants/useMixPanel.dart';
import 'package:iskcon/screens/UpcomingEvents/aboutEvent.dart';
import 'package:shimmer/shimmer.dart';

class EventsListView extends StatefulWidget {
  const EventsListView({super.key});

  @override
  State<EventsListView> createState() => _EventsListViewState();
}

class _EventsListViewState extends State<EventsListView> {
  Future<void> sendTracking({title}) async {
    await UseMixPanel().sendTracking(
        event: "Clicked on $title in Events (Category level 1) in Home");
  }

  @override
  Widget build(BuildContext context) {
    final date = DateFormat.yMMMd('en_US');
    return FutureBuilder(
        future: DataBaseSerice().eventsList(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? ListView.builder(
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
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data.docs[index];
                    return ListTile(
                      leading: Container(
                        width: 100,
                        alignment: Alignment.centerLeft,
                        child: Image.network(
                          data.data()['resizedCoverImage'] != null &&
                                  data.data()['resizedCoverImage']['thumb'] !=
                                      null
                              ? data['resizedCoverImage']['thumb']
                              : data['coverImage'],
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      onTap: () async {
                        await sendTracking(title: data['title']);
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => AboutEvent(
                                      title: data['title']
                                          .toString()
                                          .toUpperCase(),
                                      data: data,
                                      coverImage: data['coverImage'],
                                      // donationAllowed:
                                      //     data.data()['donationAllowed'],
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
