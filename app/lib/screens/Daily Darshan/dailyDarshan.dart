// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iskcon/constants/databaseService.dart';
import 'package:iskcon/constants/useMixPanel.dart';
import 'package:iskcon/screens/pictures/categoryL3.dart';
import 'package:iskcon/screens/pictures/pictureList.dart';
import 'package:iskcon/widgets/customAppBar.dart';
import 'package:shimmer/shimmer.dart';

class DailyDarshan extends StatefulWidget {
  final String title;
  const DailyDarshan({super.key, required this.title});

  @override
  State<DailyDarshan> createState() => _DailyDarshanState();
}

class _DailyDarshanState extends State<DailyDarshan> {
  var id;
  var darshanId;
  bool isLoadin = false;
  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    setState(() {
      isLoadin = true;
    });

    setState(() {
      isLoadin = false;
    });
  }

  Future<void> sendTracking({title}) async {
    await UseMixPanel().sendTracking(
        event: "Clicked on $title in Daily Darshan (Category level 1) in Home");
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: CustomAppBar(title: widget.title)),
      body: FutureBuilder(
          future: DataBaseSerice().getDailyDarshan(),
          builder: (context, snapshot) {
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
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio:
                                MediaQuery.of(context).size.width / 370,
                            crossAxisSpacing: 20.0,
                            mainAxisSpacing: 15.0,
                            crossAxisCount: 2,
                          ),
                          itemBuilder: (context, index) {
                            var data = snapshot.data.docs[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: InkWell(
                                onTap: () async {
                                  await sendTracking(title: data['name']);
                                  data.data()['isSubCategory'] == true
                                      ? Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  PicturesCategoryL3(
                                                    title: data['name'],
                                                    id1: ' widget.id',
                                                    id2: data.id,
                                                  )))
                                      : Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) => PictureList(
                                                    title: data['name'],
                                                    id: data.id,
                                                    description: snapshot.data
                                                                    .docs[index]
                                                                    .data()[
                                                                'description'] ==
                                                            null
                                                        ? ''
                                                        : data['description'],
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
                                            alignment: Alignment.center,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(
                                                      10)), // Image border
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
                                                loadingBuilder:
                                                    (BuildContext context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return SizedBox(
                                                    height: 120,
                                                    width: size.width * 0.5,
                                                    child: Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Colors.white,
                                                        value: loadingProgress
                                                                    .expectedTotalBytes !=
                                                                null
                                                            ? loadingProgress
                                                                    .cumulativeBytesLoaded /
                                                                loadingProgress
                                                                    .expectedTotalBytes!
                                                            : null,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Center(
                                            child: Text(
                                              data['name'],
                                              maxLines: 2,
                                              softWrap: true,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
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
