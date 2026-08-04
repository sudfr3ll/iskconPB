import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iskcon/constants/provider.dart';
import 'package:iskcon/screens/About%20us/AboutUsScreen.dart';
import 'package:iskcon/screens/contactUs/contactUsTab.dart';
import 'package:iskcon/screens/socialMedia.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ModalBottmSheet extends StatefulWidget {
  final AnimationController animationController;
  const ModalBottmSheet({super.key, required this.animationController});

  @override
  State<ModalBottmSheet> createState() => _ModalBottmSheetState();
}

class _ModalBottmSheetState extends State<ModalBottmSheet>
    with SingleTickerProviderStateMixin {
  String adnroidLink = '';
  String iosLink = '';

  @override
  void initState() {
    super.initState();
    getShareLink();
  }

  void getShareLink() {
    FirebaseFirestore.instance
        .collection('Settings')
        .doc('appLink')
        .get()
        .then((value) {
      setState(() {
        adnroidLink = value.get('android');
        iosLink = value.get('ios');
        print(iosLink);
        print(adnroidLink);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppState>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xff9C5AB1),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50))),
        height: 200,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: InkWell(
                    onTap: () {
                      if (provider.change == true) {
                        provider.changebool();
                        widget.animationController.reverse();
                        Navigator.pop(context);
                      }
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => ContactUsTab()));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.phone,
                          color: Colors.white,
                        ),
                        Text(
                          'Contact Us',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  )),
                  Expanded(
                      child: InkWell(
                    onTap: () {
                      if (provider.change == true) {
                        provider.changebool();
                        widget.animationController.reverse();
                        Navigator.pop(context);
                      }
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => SocialMedial()));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.thumb_up,
                          color: Colors.white,
                        ),
                        Text(
                          'Social Media',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  )),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: InkWell(
                    onTap: () {
                      if (provider.change == true) {
                        provider.changebool();
                        widget.animationController.reverse();
                        Navigator.pop(context);
                      }
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => AboutUsScreen()),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info,
                          color: Colors.white,
                        ),
                        Text(
                          'About Us',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  )),
                  Expanded(
                      child: InkWell(
                    onTap: () {
                      // if (provider.change == true) {
                      //   provider.changebool();
                      //   Navigator.pop(context);
                      // }
                      if (Platform.isIOS) {
                        SharePlus.instance.share(
  ShareParams(
    text: iosLink,
  ),
);
                      } else {
                        SharePlus.instance.share(
  ShareParams(
    text: adnroidLink,
  ),
);
                      } // Navigator.push(
                      //   context,
                      //   CupertinoPageRoute(builder: (context) => VideosScreen()),
                      // );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                        Text(
                          'Share App',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
