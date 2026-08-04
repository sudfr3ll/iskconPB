import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iskcon/constants/databaseService.dart';
import 'package:iskcon/screens/pictures/categoryL3.dart';
import 'package:iskcon/screens/pictures/pictureList.dart';
import 'package:iskcon/widgets/customAppBar.dart';
import 'package:shimmer/shimmer.dart';

class PicturesCategoryL2 extends StatefulWidget {
  final String title;
  final String id;
  const PicturesCategoryL2({super.key, required this.title, required this.id});

  @override
  State<PicturesCategoryL2> createState() => _PicturesCategoryL2State();
}

class _PicturesCategoryL2State extends State<PicturesCategoryL2> {
  @override
  Widget build(BuildContext context) {
    final date = DateFormat('yyyy');
    final size = MediaQuery.of(context).size;
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
          future: DataBaseSerice().categoryL2(widget.id, 'pictures'),
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
                                onTap: () {
                                  data.data()['isSubCategory'] == true
                                      ? Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  PicturesCategoryL3(
                                                    title: data['name'],
                                                    id1: widget.id,
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
                                          // Align(
                                          //     alignment: Alignment.topRight,
                                          //     child: IconButton(
                                          //         onPressed: () {
                                          //           showModalBottomSheet(
                                          //               shape:
                                          //                   RoundedRectangleBorder(
                                          //                 borderRadius:
                                          //                     BorderRadius.only(
                                          //                         topLeft: Radius
                                          //                             .circular(
                                          //                                 20),
                                          //                         topRight: Radius
                                          //                             .circular(
                                          //                                 20)),
                                          //               ),
                                          //               enableDrag: true,
                                          //               context: context,
                                          //               builder: (context) =>
                                          //                   Padding(
                                          //                     padding: const EdgeInsets
                                          //                             .symmetric(
                                          //                         horizontal:
                                          //                             8.0),
                                          //                     child: ShowDescription(
                                          //                         data: data,
                                          //                         description: data[
                                          //                             'description'],
                                          //                         image: data.data()['resizedCoverImage'] !=
                                          //                                     null &&
                                          //                                 data.data()['resizedCoverImage']['thumb'] !=
                                          //                                     null
                                          //                             ? data['resizedCoverImage']
                                          //                                 [
                                          //                                 'thumb']
                                          //                             : data[
                                          //                                 'coverImage'],
                                          //                         title: data[
                                          //                             'name']),
                                          //                   ));
                                          //         },
                                          //         icon: Icon(
                                          //           Icons.info_outline,
                                          //           color: Colors.white,
                                          //           size: 20,
                                          //         )))
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
