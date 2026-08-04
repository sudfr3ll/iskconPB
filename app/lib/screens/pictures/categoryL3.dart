import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iskcon/constants/databaseService.dart';
import 'package:iskcon/screens/pictures/pictureList.dart';
import 'package:shimmer/shimmer.dart';

class PicturesCategoryL3 extends StatefulWidget {
  final String title;
  final String id1;
  final String id2;
  const PicturesCategoryL3(
      {super.key, required this.title, required this.id1, required this.id2});

  @override
  State<PicturesCategoryL3> createState() => _PicturesCategoryL3State();
}

class _PicturesCategoryL3State extends State<PicturesCategoryL3> {
  @override
  Widget build(BuildContext context) {
    final date = DateFormat('yyyy');
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
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
      ),
      body: FutureBuilder(
          future:
              DataBaseSerice().categoryL3(widget.id1, widget.id2, 'pictures'),
          builder: (BuildContext context, snapshot) {
            return !snapshot.hasData
                ? Container(
                    margin: EdgeInsets.all(16.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: 6,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.9,
                        crossAxisSpacing: 20.0,
                        mainAxisSpacing: 20.0,
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  )
                : snapshot.data.docs.length == 0
                    ? Center(
                        child: Text('No Data Found'),
                      )
                    : Container(
                        margin: EdgeInsets.all(16.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio:
                                MediaQuery.of(context).size.width /
                                    (MediaQuery.of(context).size.height / 2),
                            crossAxisSpacing: 20.0,
                            mainAxisSpacing: 20.0,
                            crossAxisCount: 2,
                          ),
                          itemBuilder: (context, index) {
                            var data = snapshot.data.docs[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => PictureList(
                                              title: data['name'],
                                              id: data.id,
                                            )));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(17, 112, 114, 1),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                10), // Image border
                                            child: Image.network(
                                              data.data()['resizedCoverImage'] !=
                                                          null &&
                                                      data.data()['resizedCoverImage']
                                                              ['thumb'] !=
                                                          null
                                                  ? data['resizedCoverImage']
                                                      ['thumb']
                                                  : data['coverImage'],
                                              fit: BoxFit.cover,
                                              height: 120,
                                              width: size.width * 0.5,
                                            ),
                                          ),
                                        ),
                                        Align(
                                            alignment: Alignment.topRight,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                date.format(data
                                                    .data()['createdAt']
                                                    .toDate()),
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ))
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      data.data()['name'],
                                      style: TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
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
