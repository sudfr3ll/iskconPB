// ignore_for_file: list_remove_unrelated_type

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:iskcon/constants/databaseService.dart';
import 'package:iskcon/screens/pictures/pictureView.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

class PictureList extends StatefulWidget {
  final String? title;
  final String? id;
  final String? description;
  const PictureList({
    super.key,
    required this.title,
    required this.id,
    this.description,
  });

  @override
  State<PictureList> createState() => _PictureListState();
}

class _PictureListState extends State<PictureList> {
  bool isChecked = false;
  bool isLoading = false;
  bool isget = false;
  bool isSelectAll = false;
  Directory? temp;
  List<Map<String, dynamic>> shareData = [];
  int? selectedIndex;
  Color getColor(Set<WidgetState> states) {
    const Set<WidgetState> interactiveStates = <WidgetState>{
      WidgetState.pressed,
      WidgetState.hovered,
      WidgetState.focused,
    };

    return Color.fromRGBO(17, 112, 114, 1);
  }

  Future<void> shareImage(List<Map<String, dynamic>> data) async {
    setState(() {
      isLoading = true;
    });
    for (int i = 0; i < shareData.length; i++) {
      print(data[i]['mob']);
      print(data[i]['title']);
      final response = await get(Uri.parse(data[i]['mob']));
      temp = await getTemporaryDirectory();
      final File imageFile = File('${temp!.path}/${data[i]['title']}.png');
      imageFile.writeAsBytesSync(response.bodyBytes);
    }
    SharePlus.instance
        .share(
          ShareParams(
            files: shareData
                .map((e) => XFile('${temp!.path}/${e['title']}.png'))
                .toList(),
          ),
        )
        .whenComplete(() {
          setState(() {
            isLoading = false;
          });
        });
  }

  List chekList = [];
  bool showCheck = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title!),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff9C5AB1), Color(0xff9C5AB1)],
            ),
          ),
        ),
        toolbarHeight: 46,
        actions: [
          isLoading == true
              ? Center(
                  child: CircularProgressIndicator(
                    color: Color.fromRGBO(17, 112, 114, 1),
                  ),
                )
              : IconButton(
                  onPressed: () {
                    try {
                      if (showCheck == false) {
                        setState(() {
                          showCheck = true;
                        });
                      } else {
                        shareData.isEmpty
                            ? Fluttertoast.showToast(msg: 'Please select image')
                            : shareImage(shareData).whenComplete(() {
                                setState(() {
                                  chekList.clear();
                                  shareData.clear();
                                  showCheck = false;
                                });
                              });
                      }
                    } catch (e) {
                      Exception();
                    }
                  },
                  icon: Icon(Icons.share),
                ),
          showCheck == false
              ? Container()
              : IconButton(
                  onPressed: () {
                    setState(() {
                      showCheck = false;
                      isSelectAll = false;
                      isLoading = false;
                      chekList.clear();
                      shareData.clear();
                      print(chekList);
                    });
                  },
                  icon: Icon(Icons.cancel_outlined),
                ),
        ],
      ),
      body: StreamBuilder(
        stream: DataBaseSerice().getCategoryList(
          'Pictures',
          widget.id.toString(),
        ),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return !snapshot.hasData
              ? Container(
                  margin: EdgeInsets.all(16.0),
                  child: GridView.builder(
                    physics: BouncingScrollPhysics(),
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
                        child: Container(color: Colors.white),
                      );
                    },
                  ),
                )
              : snapshot.data.docs.length == 0
              ? Center(child: Text('No Data Found'))
              : Column(
                  children: [
                    widget.description == ''
                        ? SizedBox()
                        : FittedBox(
                            fit: BoxFit.fitHeight,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: size.height * 0.18,
                              ),
                              child: SingleChildScrollView(
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  alignment: Alignment.topCenter,
                                  width: size.width,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 234, 195, 240),
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Color.fromRGBO(17, 112, 114, 1),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    widget.description!,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),

                    // Container(
                    //   decoration: BoxDecoration(
                    //       color: Color.fromARGB(255, 234, 195, 240),
                    //       border: Border(
                    //           bottom: BorderSide(
                    //               color: Color.fromRGBO(17, 112, 114, 1),
                    //               width: 1))),
                    //   height: size.height * 0.18,
                    //   width: size.width,
                    //   padding: EdgeInsets.all(8.0),
                    //   alignment: Alignment.topCenter,
                    //   child: Column(
                    //     children: [
                    //       Expanded(
                    //         child: SingleChildScrollView(
                    //           child: Text(
                    //             widget.description!,
                    //             textAlign: TextAlign.center,
                    //           ),
                    //         ),
                    //       ),
                    //       Icon(
                    //         Icons.keyboard_arrow_down,
                    //         color: Colors.white,
                    //       )
                    //     ],
                    //   ),
                    // ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Container(
                          margin: EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              showCheck == false
                                  ? SizedBox()
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0,
                                        vertical: 12,
                                      ),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              isSelectAll = !isSelectAll;
                                            });
                                            if (isSelectAll) {
                                              for (
                                                int i = 0;
                                                i < snapshot.data.docs.length;
                                                i++
                                              ) {
                                                if (!chekList.contains(i)) {
                                                  setState(() {
                                                    chekList.add(i);
                                                    print(chekList);
                                                    shareData.add({
                                                      'title':
                                                          '${snapshot.data.docs[i]['title']} ${i + 1}',
                                                      'mob': snapshot
                                                          .data
                                                          .docs[i]['image']['mob'],
                                                      'index': i,
                                                    });
                                                  });
                                                }
                                                //  else {
                                                //   setState(() {
                                                //     isSelectAll = false;
                                                //     chekList.remove(i);
                                                //     // shareData.removeAt(index1);

                                                //     shareData
                                                //         .removeWhere((value) {
                                                //       var result =
                                                //           value['index'] == i;
                                                //       print(
                                                //           'Result is : $result');
                                                //       return result;
                                                //     });
                                                //   });
                                                // }
                                              }
                                            } else {
                                              setState(() {
                                                chekList.clear();
                                                shareData.clear();
                                              });
                                            }
                                          },
                                          child: Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: isSelectAll == true
                                                  ? Color.fromRGBO(
                                                      17,
                                                      112,
                                                      114,
                                                      1,
                                                    )
                                                  : Colors.grey.shade300,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                    vertical: 8.0,
                                                  ),
                                              child: Wrap(
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.check_circle_outline,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text('Select All'),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                              GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data.docs.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio:
                                          MediaQuery.of(context).size.width /
                                          370,
                                      crossAxisSpacing: 20.0,
                                      mainAxisSpacing: 15.0,
                                      crossAxisCount: 2,
                                    ),
                                itemBuilder: (context, index1) {
                                  var data = snapshot.data.docs[index1];
                                  return InkWell(
                                    onLongPress: () {
                                      setState(() {
                                        showCheck = true;
                                        // chekList.add(index1);
                                        // chekList.add(index1);
                                        // shareData.add({
                                        //   'title':
                                        //       '${snapshot.data.docs[index1]['title']} ${index1 + 1}',
                                        //   'mob': snapshot.data.docs[index1]['image']
                                        //       ['thumb']
                                        // });
                                        // print(index1.toString());
                                      });
                                    },
                                    onTap: () {
                                      if (showCheck == true) {
                                        try {
                                          bool found = false;
                                          for (
                                            int i = 0;
                                            i < shareData.length;
                                            i++
                                          ) {
                                            if (shareData[i]['index'] ==
                                                index1) {
                                              setState(() {
                                                found = true;
                                              });
                                            }
                                          }
                                          print('Found is :  $found');
                                          if (!found) {
                                            setState(() {
                                              // isChecked = true;
                                              chekList.add(index1);
                                              shareData.add({
                                                'title':
                                                    '${snapshot.data.docs[index1]['title']} ${index1 + 1}',
                                                'mob': snapshot
                                                    .data
                                                    .docs[index1]['image']['mob'],
                                                'index': index1,
                                              });
                                              // .add(
                                              //   data['title'],
                                              // );
                                              // print(chekList[index1]);
                                              // print(index1.toString());
                                              // print(chekList);
                                            });
                                          } else {
                                            setState(() {
                                              // isChecked = false;
                                              chekList.remove(index1);
                                              // shareData.removeAt(index1);

                                              shareData.removeWhere((value) {
                                                var result =
                                                    value['index'] == index1;
                                                print('Result is : $result');
                                                return result;
                                              });
                                            });
                                          }
                                          for (
                                            int i = 0;
                                            i < shareData.length;
                                            i++
                                          ) {
                                            print(
                                              'index is : ${shareData[i]['index']}',
                                            );
                                          }
                                        } catch (e) {
                                          Exception();
                                        }
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PictureViewList(
                                                  data: snapshot.data.docs,
                                                  index: index1,
                                                ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(17, 112, 114, 1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          Stack(
                                            children: [
                                              Container(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        10,
                                                      ), // Image border
                                                  child: Image.network(
                                                    data['image']['thumb'],
                                                    fit: BoxFit.cover,
                                                    height: 158,
                                                    width: size.width * 0.5,
                                                    loadingBuilder:
                                                        (
                                                          BuildContext context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                          loadingProgress,
                                                        ) {
                                                          if (loadingProgress ==
                                                              null) {
                                                            return child;
                                                          }
                                                          return SizedBox(
                                                            height: 120,
                                                            width:
                                                                size.width *
                                                                0.5,
                                                            child: Center(
                                                              child: CircularProgressIndicator(
                                                                color: Colors
                                                                    .white,
                                                                value:
                                                                    loadingProgress
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
                                              showCheck == false
                                                  ? SizedBox()
                                                  : Container(
                                                      height: 158,
                                                      width: size.width * 0.5,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                        color: Colors.black
                                                            .withValues(
                                                              alpha: .5,
                                                            ),
                                                      ),
                                                    ),
                                              showCheck == false
                                                  ? Container()
                                                  //     : !chekList.contains(index1)
                                                  //         ? Text('')
                                                  //         : Container(
                                                  //             alignment: Alignment.center,
                                                  //             child: Text(
                                                  //               '${index1+1}',
                                                  //               style: TextStyle(
                                                  //                   color: Colors.white,
                                                  //                   fontSize: 20),
                                                  //             ),
                                                  //           ),
                                                  : Checkbox(
                                                      shape: CircleBorder(),
                                                      checkColor: Colors.white,
                                                      fillColor:
                                                          WidgetStateProperty.resolveWith(
                                                            getColor,
                                                          ),
                                                      value: chekList.contains(
                                                        index1,
                                                      ),
                                                      onChanged: (bool? value) {
                                                        try {
                                                          bool found = false;
                                                          for (
                                                            int i = 0;
                                                            i <
                                                                shareData
                                                                    .length;
                                                            i++
                                                          ) {
                                                            if (shareData[i]['index'] ==
                                                                index1) {
                                                              setState(() {
                                                                found = true;
                                                              });
                                                            }
                                                          }
                                                          print(
                                                            'Found is :  $found',
                                                          );
                                                          if (!found) {
                                                            setState(() {
                                                              // isChecked = true;
                                                              chekList.add(
                                                                index1,
                                                              );
                                                              shareData.add({
                                                                'title':
                                                                    '${snapshot.data.docs[index1]['title']} ${index1 + 1}',
                                                                'mob': snapshot
                                                                    .data
                                                                    .docs[index1]['image']['mob'],
                                                                'index': index1,
                                                              });
                                                              // .add(
                                                              //   data['title'],
                                                              // );
                                                              // print(chekList[index1]);
                                                              // print(index1.toString());
                                                              // print(chekList);
                                                            });
                                                          } else {
                                                            setState(() {
                                                              // isChecked = false;
                                                              chekList.remove(
                                                                index1,
                                                              );
                                                              // shareData.removeAt(index1);

                                                              shareData.removeWhere((
                                                                value,
                                                              ) {
                                                                var result =
                                                                    value['index'] ==
                                                                    index1;
                                                                print(
                                                                  'Result is : $result',
                                                                );
                                                                return result;
                                                              });
                                                            });
                                                          }
                                                          for (
                                                            int i = 0;
                                                            i <
                                                                shareData
                                                                    .length;
                                                            i++
                                                          ) {
                                                            print(
                                                              'index is : ${shareData[i]['index']}',
                                                            );
                                                          }
                                                        } catch (e) {
                                                          Exception();
                                                        }
                                                        // if (!chekList
                                                        //     .contains(index1)) {
                                                        //   setState(() {
                                                        //     // isChecked = true;
                                                        //     chekList.add(index1);
                                                        //     shareData.add({
                                                        //       'title':
                                                        //           '${snapshot.data.docs[index1]['title']}',
                                                        //       'mob': snapshot.data
                                                        //               .docs[index1]
                                                        //           ['image']['mob']
                                                        //     });
                                                        //     // .add(
                                                        //     //   data['title'],
                                                        //     // );
                                                        //     // print(chekList[index1]);
                                                        //     // print(index1.toString());
                                                        //     print(shareData);
                                                        //     print(chekList);
                                                        //   });
                                                        // } else {
                                                        //   setState(() {
                                                        //     // isChecked = false;
                                                        //     chekList.remove(index1);
                                                        //     shareData.removeWhere(
                                                        //       (element) {
                                                        //         return element[
                                                        //                     'title'] ==
                                                        //                 snapshot.data
                                                        //                             .docs[
                                                        //                         index1]
                                                        //                     [
                                                        //                     'title'] &&
                                                        //             element['mob'] ==
                                                        //                 snapshot.data
                                                        //                             .docs[
                                                        //                         index1]
                                                        //                     [
                                                        //                     'image']['mob'];
                                                        //       },
                                                        //     );
                                                        //     print(chekList);
                                                        //   });
                                                        // }
                                                      },
                                                      // onChanged: (bool? value) {
                                                      //   if (chekList
                                                      //       .contains(index1)) {
                                                      //     setState(() {
                                                      //       // isChecked = false;
                                                      //       chekList.remove(index1);
                                                      //       print(chekList[index1]);
                                                      //     });
                                                      //   } else {
                                                      //     setState(() {
                                                      //       // isChecked = true;
                                                      //       chekList.add(index1);
                                                      //       shareData.add({
                                                      //         'title':
                                                      //             '${data['title']} ${index1 + 1}',
                                                      //         'mob': data['image']
                                                      //             ['thumb']
                                                      //       });
                                                      //       // .add(
                                                      //       //   data['title'],
                                                      //       // );
                                                      //       // print(chekList[index1]);
                                                      //       // print(shareData);
                                                      //     });
                                                      //   }
                                                      // },
                                                    ),
                                              // Align(
                                              //     alignment: Alignment.topRight,
                                              //     child: IconButton(
                                              //         onPressed: () {
                                              //           showModalBottomSheet(
                                              //               shape:
                                              //                   RoundedRectangleBorder(
                                              //                 borderRadius: BorderRadius.only(
                                              //                     topLeft: Radius
                                              //                         .circular(
                                              //                             20),
                                              //                     topRight: Radius
                                              //                         .circular(
                                              //                             20)),
                                              //               ),
                                              //               enableDrag: true,
                                              //               context: context,
                                              //               builder:
                                              //                   (context) =>
                                              //                       Padding(
                                              //                         padding: const EdgeInsets
                                              //                                 .symmetric(
                                              //                             horizontal:
                                              //                                 8.0),
                                              //                         child: ShowDescription(
                                              //                             data:
                                              //                                 data,
                                              //                             description: data[
                                              //                                 'description'],
                                              //                             image: data['image']
                                              //                                 [
                                              //                                 'thumb'],
                                              //                             title:
                                              //                                 data['title']),
                                              //                       ));
                                              //         },
                                              //         icon: Icon(
                                              //           Icons.info_outline,
                                              //           color: Colors.white,
                                              //           size: 20,
                                              //         )))
                                            ],
                                          ),
                                          // SizedBox(
                                          //   height: 10,
                                          // ),
                                          // Flexible(
                                          //   child: Padding(
                                          //     padding:
                                          //         const EdgeInsets.symmetric(
                                          //             horizontal: 8.0),
                                          //     child: Center(
                                          //       child: Text(
                                          //         '${data['title']}',
                                          //         maxLines: 2,
                                          //         style: TextStyle(
                                          //             color: Colors.white,fontSize: 16),
                                          //         textAlign: TextAlign.center,
                                          //         overflow:
                                          //             TextOverflow.ellipsis,
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
