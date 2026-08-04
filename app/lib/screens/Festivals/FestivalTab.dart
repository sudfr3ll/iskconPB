// ignore_for_file: unused_local_variable, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iskcon/screens/Festivals/FestivalGrid.dart';
import 'package:iskcon/screens/Festivals/FestivalList.dart';

class FestivalTab extends StatefulWidget {
  final String title;
  const FestivalTab({super.key, required this.title});

  @override
  State<FestivalTab> createState() => _FestivalTabState();
}

class _FestivalTabState extends State<FestivalTab> {
  String type = 'grid';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final date = DateFormat.yMMMd('en_US');
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 46,
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          Image.asset(
            'assets/images/logo.png',
            height: 40,
            width: 40,
          ),
          SizedBox(
            width: 10,
          )
        ],
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(),
                    IconButton(
                      color: type == 'grid' ? Colors.amber : null,
                      icon: Icon(
                        Icons.grid_view,
                      ),
                      onPressed: () {
                        if (type == 'list') {
                          setState(() {
                            type = 'grid';
                          });
                        }
                      },
                    ),
                    IconButton(
                      color: type == 'list' ? Colors.amber : null,
                      icon: Icon(Icons.list),
                      onPressed: () {
                        if (type == 'grid') {
                          setState(() {
                            type = 'list';
                          });
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
            Divider(),
            type == 'grid'
                ? FestivalGrid()
                : Container(
                    height: size.height * 0.76,
                    child: FestivalList(
                      title: widget.title,
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
