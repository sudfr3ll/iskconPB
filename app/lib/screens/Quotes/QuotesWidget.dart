import 'package:flutter/material.dart';

class QuotesWidget extends StatelessWidget {
  final String para;
  final String date;
  final dynamic data;

  const QuotesWidget({
    super.key,
    required this.date,
    required this.para,
    this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          // Container(
          //   decoration: BoxDecoration(
          //     color: Color.fromARGB(255, 112, 5, 195),
          //     borderRadius: BorderRadius.only(
          //       bottomLeft: Radius.circular(50),
          //       topRight: Radius.circular(50),
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Transform.rotate(
                        angle: 91.1,
                        child: Icon(
                          Icons.format_quote_sharp,
                          color: Color.fromRGBO(119, 97, 172, 1),
                          //  rgb(119,97,172)
                          size: 45,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      para,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge!.merge(
                            TextStyle(
                              fontWeight: FontWeight.w400,
                              // color: Color.fromARGB(255, 0, 138, 43),
                            ),
                          ),
                      maxLines: 12,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.format_quote_sharp,
                        color: Color.fromRGBO(119, 97, 172, 1),
                        size: 45,
                      ),
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
