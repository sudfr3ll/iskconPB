// ignore_for_file: unnecessary_string_interpolations

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iskcon/widgets/customAppBar.dart';
import 'package:shimmer/shimmer.dart';

class FestivalList extends StatefulWidget {
  final String title;
  const FestivalList({super.key, required this.title});

  @override
  State<FestivalList> createState() => _FestivalListState();
}

class _FestivalListState extends State<FestivalList> {
  int? current_mon;
  var newfilter;
  String? month;
  List months = [
    'jan',
    'feb',
    'mar',
    'apr',
    'may',
    'jun',
    'jul',
    'aug',
    'sep',
    'oct',
    'nov',
    'dec'
  ];
  List<Color> colors = [
    Colors.amber.shade100,
    Colors.blue.shade100,
    Colors.purple.shade100,
    Colors.green.shade100,
    Colors.red.shade100
  ];
  Random random = Random();
  void getCurrentMonth() {
    var now = DateTime.now();
    current_mon = now.month;
    month = months[current_mon! - 1];
    print(months[current_mon! - 1].toString().toUpperCase());
  }

  @override
  void initState() {
    getCurrentMonth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final date = DateFormat.MMMEd();
    final festivalMonth = DateFormat("MMM");
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: CustomAppBar(title: widget.title)),
      // AppBar(
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
      body: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: DropdownButton<dynamic>(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                value: month,
                items: months
                    .map((e) => DropdownMenuItem(
                        value: e, child: Text(e.toString().toUpperCase())))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    month = value;
                  });
                  print('This is selected : $month');
                }),
          ),

          // IconButton(onPressed: () {}, icon: Icon(Icons.filter_alt))),
          Expanded(
            child: FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('Festivals')
                    .orderBy('date')
                    .get(),
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
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var data = snapshot.data!.docs[index];
                            newfilter = festivalMonth
                                .format(data.data()['date'].toDate())
                                .toLowerCase();
                            print(festivalMonth.format(data.data()['date'].toDate()));
                            var titles = data.data()['title'].toString().split('/');
                            return month != newfilter
                                ? Container()
                                : ListTile(
                                    tileColor: index % 2 == 0
                                        ? Colors.white
                                        : Colors.purple.shade50,
                                    leading: Text(
                                      '${date.format(data.data()['date'].toDate())}',
                                    ),
                                    // onTap: () {
                                    //   Navigator.push(
                                    //       context,
                                    //       CupertinoPageRoute(
                                    //           builder: (context) =>
                                    //               AboutFestival(
                                    //                 title: data['title'],
                                    //                 data: data,
                                    //               )));
                                    // },
                                    title: Container(
                                      child: ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: titles.length,
                                          itemBuilder: ((context, index1) =>
                                              titles.length <= 1
                                                  ? Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                            child: Text(
                                                                data['title'])),
                                                      ],
                                                    )
                                                  : Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text('${index1 + 1}.'),
                                                        Expanded(
                                                            child: Text(
                                                                '${titles[index1]}')),
                                                      ],
                                                    ))),
                                    ),
                                    // subtitle: Text(
                                    //   '${date.format(data['date'].toDate())}',
                                    //   style:
                                    //       Theme.of(context).textTheme.caption,
                                    // ),
                                  );
                          });
                }),
          ),
        ],
      ),
    );
  }
}
