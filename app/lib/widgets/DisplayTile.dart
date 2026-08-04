import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DisplayTile extends StatelessWidget {
  final String tileIcon;
  final String title;
  final bool isTopLeftCurved;
  final bool isTopRightCurved;
  final String imgUrl;
  const DisplayTile({
    required this.tileIcon,
    required this.title,
    required this.imgUrl,
    this.isTopLeftCurved = false,
    this.isTopRightCurved = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 108,
          decoration: BoxDecoration(
            // color: Colors.green,
            gradient: isTopLeftCurved
                ? LinearGradient(colors: [
                    Color.fromRGBO(99, 70, 167, 1),
                    Color.fromRGBO(178, 166, 206, 0)
                  ])
                : LinearGradient(colors: [
                    Color.fromRGBO(178, 166, 206, 0),
                    Color.fromRGBO(99, 70, 167, 1),
                  ]),
            borderRadius: BorderRadius.only(
              topLeft:
                  isTopLeftCurved ? Radius.circular(25) : Radius.circular(0),
              bottomRight:
                  isTopLeftCurved ? Radius.circular(25) : Radius.circular(0),
              topRight:
                  isTopRightCurved ? Radius.circular(25) : Radius.circular(0),
              bottomLeft:
                  isTopRightCurved ? Radius.circular(25) : Radius.circular(0),
              // Radius.circular(10),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Container(
            width: 200,
            height: 105,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imgUrl),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                topLeft:
                    isTopLeftCurved ? Radius.circular(25) : Radius.circular(0),
                bottomRight:
                    isTopLeftCurved ? Radius.circular(25) : Radius.circular(0),
                topRight:
                    isTopRightCurved ? Radius.circular(25) : Radius.circular(0),
                bottomLeft:
                    isTopRightCurved ? Radius.circular(25) : Radius.circular(0),
                // Radius.circular(10),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: isTopLeftCurved
                      ? Radius.circular(25)
                      : Radius.circular(0),
                  bottomRight: isTopLeftCurved
                      ? Radius.circular(25)
                      : Radius.circular(0),
                  topRight: isTopRightCurved
                      ? Radius.circular(25)
                      : Radius.circular(0),
                  bottomLeft: isTopRightCurved
                      ? Radius.circular(25)
                      : Radius.circular(0),
                  // Radius.circular(10),
                ),
                color: Colors.black12.withValues(alpha: .4),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    tileIcon,
                    color: Colors.white,
                    height: 27,
                  ),
                  // Icon(
                  //   tileIcon,
                  //   size: 27,
                  //   color: Colors.white,
                  // ),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
