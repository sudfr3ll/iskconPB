// ignore_for_file: unused_local_variable, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iskcon/constants/useMixPanel.dart';
import 'package:iskcon/screens/News/NewsGrid.dart';
import 'package:iskcon/screens/News/NewsList.dart';
import 'package:iskcon/widgets/customAppBar.dart';

class NewsTab extends StatefulWidget {
  final String title;
  const NewsTab({super.key, required this.title});

  @override
  State<NewsTab> createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
  String type = 'grid';

  Future<void> sendTracking({title}) async {
    await UseMixPanel().sendTracking(
        event: "Clicked on $title in Temple News (Category level 1) in Home");
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final date = DateFormat.yMMMd('en_US');
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
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(),
                    InkWell(
                      onTap: () {
                        if (type == 'list') {
                          setState(() {
                            type = 'grid';
                          });
                        }
                      },
                      child: Container(
                        color: type == 'grid'
                            ? Color.fromRGBO(17, 112, 114, 1)
                            : null,
                        child: Icon(Icons.grid_view,
                            color: type == 'grid' ? Colors.white : null),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                        onTap: () {
                          if (type == 'grid') {
                            setState(() {
                              type = 'list';
                            });
                          }
                        },
                        child: Container(
                          color: type == 'list'
                              ? Color.fromRGBO(17, 112, 114, 1)
                              : null,
                          child: Icon(
                            Icons.list,
                            color: type == 'list' ? Colors.white : null,
                          ),
                        ))
                  ],
                ),
              ),
            ),
            Divider(),
            type == 'grid'
                ? NewsGrid()
                : Container(
                    height: size.height * 0.76,
                    child: NewsList(),
                  )
          ],
        ),
      ),
    );
  }
}
