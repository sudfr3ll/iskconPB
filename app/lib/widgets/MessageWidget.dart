import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iskcon/screens/Blogs/BlogView.dart';

class MessageWidget extends StatelessWidget {
  final String imgUrl;
  final dynamic data;
  final String imgContent;
  final String para1;
  final String author;
  // final String para3;
  final String date;

  const MessageWidget({
    required this.date,
    required this.imgContent,
    required this.imgUrl,
    required this.para1,
    required this.author,
    // required this.para3,
    super.key,
    this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 248, 240, 255),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
          topRight: Radius.circular(35),
        ),
      ),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(imgUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                height: 160,
                width: double.infinity,
                // child: Center(
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 20.0),
                //     child: Text(
                //       imgContent,
                //       textAlign: TextAlign.center,
                //       style: TextStyle(
                //         color: Colors.white,
                //         fontSize: 16,
                //         fontWeight: FontWeight.w500,
                //       ),
                //     ),
                //   ),
                // )
              ),
              Container(
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: .2),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    imgContent,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              para1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 10),
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 10),
          //   child: Text(
          //     para2,
          //     textAlign: TextAlign.center,
          //     style: TextStyle(
          //       fontWeight: FontWeight.w400,
          //     ),
          //   ),
          // ),
          SizedBox(height: 10),
          Container(
            child: Text(
              author,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 10),

          data.data()['messageUrl'] != null
              ? InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => BlogView(
                                  title: author,
                                  url: data['messageUrl'],
                                )));
                  },
                  child: Text(
                    data['messageUrl'],
                    style: TextStyle(color: Colors.blue),
                  ))
              : SizedBox(),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Posted On:',
                    style: TextStyle(
                      color: Color.fromRGBO(17, 112, 114, 1),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    date,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(17, 112, 114, 1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
