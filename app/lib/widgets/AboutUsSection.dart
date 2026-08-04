import 'package:flutter/material.dart';

class AboutUsSection extends StatelessWidget {
  final String imgUrl;
  final String imgContent;
  final String para1;
  final String para2;
  final String para3;
  final String para4;

  const AboutUsSection({
    this.imgContent = '',
    required this.imgUrl,
    this.para1 = '',
    this.para2 = '',
    this.para3 = '',
    this.para4 = '',
    super.key,
    required Size screen,
  })  : _screen = screen;

  final Size _screen;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            child: imgContent != ''
                ? Container(
                    width: double.infinity,
                    height: _screen.height * 0.25,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(imgUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 10,
                          ),
                          color: Color.fromRGBO(17, 112, 114, .8),
                          child: Text(
                            imgContent,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  )
                : Container(
                    width: double.infinity,
                    height: _screen.height * 0.25,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(245, 231, 218, 1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(imgUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            child: para1 != ''
                ? Text(
                    para1,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.3,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : null,
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            child: para2 != ''
                ? Text(
                    para2,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.3,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : null,
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            child: para3 != ''
                ? Text(
                    para3,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.3,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : null,
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            child: para3 != ''
                ? Text(
                    para4,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.3,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
