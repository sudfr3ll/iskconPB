import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VideosScreenTile extends StatelessWidget {
  const VideosScreenTile({
    super.key,
    required this.screen,
    required this.bgImageUrl,
    this.transparentBg,
    required this.title,
    required this.data,
    this.imgPath,
    this.type,
  });

  final Size screen;
  final String bgImageUrl;
  final Color? transparentBg;
  final String title;
  final String? type;
  final String? imgPath;
  final dynamic data;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color.fromRGBO(17, 112, 114, 1),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            image: DecorationImage(
              image: data.data()['coverImage'] == null ||
                      data.data()['coverImage'] == ''
                  ? AssetImage('assets/images/defaultimg.jpg') as ImageProvider
                  : NetworkImage(bgImageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.6),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
        ),
        Positioned(
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(80),
              ),
              // color: Color.fromRGBO(1, 172, 240, 0.8),
              color: transparentBg,
            ),
            height: 180,
            width: screen.width * 0.65,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  type == 'video'
                      ? SvgPicture.asset(
                          'assets/svg/031-play-button.svg',
                          height: 50,
                          color: Colors.white,
                        )
                      : SizedBox(),
                  SizedBox(height: 15),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
