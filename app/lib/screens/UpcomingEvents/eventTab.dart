// ignore_for_file: unused_local_variable, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iskcon/constants/useMixPanel.dart';
import 'package:iskcon/screens/UpcomingEvents/eventsGrid.dart';
import 'package:iskcon/screens/UpcomingEvents/eventsList.dart';
import 'package:iskcon/widgets/customAppBar.dart';

class EventTab extends StatefulWidget {
  final String title;
  const EventTab({super.key, required this.title});

  @override
  State<EventTab> createState() => _EventTabState();
}

class _EventTabState extends State<EventTab> {
  String type = 'grid';



Future<void> sendTracking({title}) async {
    await UseMixPanel().sendTracking(
        event: "Clicked on $title in Events (Category level 1) in Home");
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
      body: Column(
        children: [
          Expanded(
            flex: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Text(
                  //   type == 'grid' ? 'GRID VIEW' : 'LIST VIEW',
                  //   style: TextStyle(
                  //     color: Color.fromRGBO(142, 177, 153, 1),
                  //   ),
                  // ),
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
                  // IconButton(
                  //   color: type == 'grid' ? Colors.amber : null,
                  //   icon: Icon(
                  //     Icons.grid_view,
                  //   ),
                  //   onPressed: () {
                  //     if (type == 'list') {
                  //       setState(() {
                  //         type = 'grid';
                  //       });
                  //     }
                  //   },
                  // ),
                  // IconButton(
                  //   color: type == 'list' ? Colors.amber : null,
                  //   icon: Icon(Icons.list),
                  //   onPressed: () {
                  //     if (type == 'grid') {
                  //       setState(() {
                  //         type = 'list';
                  //       });
                  //     }
                  //   },
                  // )
                ],
              ),
            ),
          ),
          Divider(
            height: 0,
          ),
          type == 'grid'
              ? EventsGrid()
              : Container(
                  height: size.height * 0.76,
                  child: EventsListView(),
                )
        ],
      ),
    );
  }
}
