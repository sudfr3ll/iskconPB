// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iskcon/constants/databaseService.dart';
import 'package:iskcon/models/urlLauncher.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class ReachUs extends StatefulWidget {
  const ReachUs({super.key});

  @override
  State<ReachUs> createState() => _ReachUsState();
}

class _ReachUsState extends State<ReachUs> {
  // final String _whatsApp = 'https://chat.whatsapp.com/JK5l2G87kFE9EF1nzC9Yak';

  // whatsaapURl(url) async {
  //   UrlLaunchers(url);
  // }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: DataBaseSerice().reachUs(),
        builder: (context, snapshot) {
          var data = snapshot.data;

          return !snapshot.hasData
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.purple,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text('Loading...')
                    ],
                  ),
                )
              : Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: InkWell(
                          onTap: () =>
                              MapsLauncher.launchQuery(data['address']),
                          child: Row(
                            children: [
                              Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                    color: Colors.orange.shade50,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(50),
                                        bottomRight: Radius.circular(50))),
                                child: Center(
                                    child: SvgPicture.asset(
                                  'assets/svg/024-pin.svg',
                                  height: 30,
                                  color: Colors.orange,
                                )
                                    // Icon(
                                    //   Icons.location_on,
                                    //   color: Colors.orange,
                                    //   size: 30,
                                    // ),
                                    ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Text(
                                  data['address'],
                                  textAlign: TextAlign.start,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: InkWell(
                          onTap: () async {
                            Uri phoneno = Uri.parse('tel:${data['phone'][0]}');
                            if (await launchUrl(phoneno)) {
                            } else {}
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                    color: Colors.purple.shade50,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(50),
                                        bottomRight: Radius.circular(50))),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/svg/025-phone-call.svg',
                                    color: Colors.purple,
                                    height: 30,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                  child: Row(
                                children: List.generate(data['phone'].length,
                                    (index) => Text(data['phone'][index])),
                              )
                                  // Text(
                                  //   '+91-11-25222851, +91-11-25227478',
                                  //   textAlign: TextAlign.start,
                                  // ),
                                  )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: InkWell(
                          onTap: () async {
                            Uri phoneno =
                                Uri.parse('mailto:${data['email'][0]}');
                            if (await launchUrl(phoneno)) {
                            } else {}
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(50),
                                        bottomRight: Radius.circular(50))),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/svg/026-email.svg',
                                    color: Colors.red,
                                    height: 30,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                  child: ListView(
                                shrinkWrap: true,
                                children: List.generate(data['email'].length,
                                    (index) => Text(data['email'][index])),
                              )
                                  // Text(
                                  //   'info@iskconpunjabibagh.com iskconpbtemple@gmail.com',
                                  //   textAlign: TextAlign.start,
                                  // ),
                                  )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: InkWell(
                          onTap: () async {
                            var whatsapp = '${data['whatsapp'][0]}';
                            var whatsappAndroid = Uri.parse(
                                "whatsapp://send?phone=$whatsapp&text=hello");
                            if (await launchUrl(whatsappAndroid,)) {
                            } else {}
                          },
                          child: Row( 
                            children: [
                              Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(50),
                                        bottomRight: Radius.circular(50))),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/svg/027-phone.svg',
                                    color: Colors.green,
                                    height: 30,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                  child: Row(
                                children: List.generate(data['whatsapp'].length,
                                    (index) => Text(data['whatsapp'][index])),
                              )
                                  //  Text(
                                  //   data['whatsapp'],
                                  //   textAlign: TextAlign.start,
                                  // ),
                                  )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          color: Color.fromRGBO(229, 235, 233, 1),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'For daily darshans and festival notifications, Click this link to get yourself connected to our official what’s app',
                                  textAlign: TextAlign.center,
                                ),
                                InkWell(
                                    onTap: () async {
                                      UrlLaunchers()
                                          .urlLaunch(data['whatsappLink']);
                                      // if (await canLaunchUrl(Uri.parse(_whatsApp))) {
                                      //   await launchUrl(Uri.parse(_whatsApp));
                                      // } else {
                                      //   throw "Could not launch $_whatsApp";
                                      // }
                                    },
                                    child: Text(
                                      data['whatsappLink'],
                                      style: TextStyle(color: Colors.blue),
                                      textAlign: TextAlign.center,
                                    )),
                                Text('OR'),
                                Text(
                                  'Send us your name & mobile number, we shall add you.',
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
        });
  }
}
