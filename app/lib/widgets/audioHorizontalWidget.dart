import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iskcon/constants/useMixPanel.dart';
import 'package:iskcon/screens/audio/bookReading.dart';
import 'package:iskcon/screens/audio/categoryL2.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

Widget audioWidget(dynamic data, context) {
  var date = DateFormat.yMMMd('en_US');

  Future<void> sendTracking({type, title}) async {
    await UseMixPanel()
        .sendTracking(event: "Clicked on $title from Temple $type in home");
  }

  return InkWell(
    onTap: () async {
      await sendTracking(
          title: data['name'].toString().toUpperCase(), type: "Audios");
      data.data()['isSubCategory'] == true
          ? Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => AudioCategoryL2(
                        title: data['name'],
                        id: data.id,
                      )))
          : Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => AudioBookReading(
                        title: data['name'],
                        id: data.id,
                      )));
    },
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      width: MediaQuery.of(context).size.width * 0.65,
      height: MediaQuery.of(context).size.height * 0.25,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: 232,
                height: 132,
                decoration: BoxDecoration(
                  // color: Colors.amber,
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(178, 166, 206, 0),
                    Color.fromRGBO(99, 70, 167, 1),
                  ]),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: .0),
                child: Container(
                  width: 230,
                  height: 130,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(data['resizedCoverImage']['thumb']),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                    child: FancyShimmerImage(
                      imageUrl: data['resizedCoverImage']['thumb'],
                      boxFit: BoxFit.cover,
                      errorWidget: SizedBox(
                        width: 230,
                        height: 130,
                        child: Image.asset(
                          'assets/images/defaultimg.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 14,
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                data['name'].toString().toUpperCase(),
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(date.format(data['createdAt'].toDate()),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    ),
  );
}
