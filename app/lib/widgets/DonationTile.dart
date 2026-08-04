// ignore_for_file: sort_child_properties_last, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iskcon/constants/useMixPanel.dart';
import 'package:iskcon/widgets/webview.dart';
import 'package:iskcon/screens/Donate/donate_by_paytm.dart';

List paymentOptions = [
  {
    'name': 'Paytm',
    'icon': 'assets/images/paytm_icon.png',
    'code': 1,
  },
  {
    'name': 'Debit & Credit Card',
    'icon': 'assets/images/CD_card_icon.png',
    'code': 2,
  },
  {
    'name': 'NetBanking',
    'icon': 'assets/images/netbanking_icon.png',
    'code': 3,
  }
];

class DonationTile extends StatefulWidget {
  final String? title;
  final Color? color1;
  final Color? color2;
  final Color? color3;
  final Color? loaderColor;
  final String? image;
  final String id;
  const DonationTile(
      {super.key,
      required this.title,
      required this.color1,
      required this.color2,
      required this.color3,
      required this.image,
      required this.id,
      required this.loaderColor});

  @override
  State<DonationTile> createState() => _DonationTileState();
}

class _DonationTileState extends State<DonationTile> {
  @override
  bool isClick = false;

  void paymentOptionSheet(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            // height: 200,

            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        "Payment options",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: paymentOptions.map((optn) {
                    return InkWell(
                      onTap: isClick
                          ? null
                          : () async {
                              setState(() {
                                isClick = true;
                              });
                              print("clicked : $isClick");
                              if (optn['code'] == 1) {
                                Navigator.pop(context);
                                await Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (ctx) => DonateByPaytm(
                                              donId: widget.id,
                                              donName: widget.title!,
                                            )));
                                setState(() {
                                  isClick = false;
                                });
                                print("clicked : $isClick");
                              }

                              if (optn['code'] == 2 || optn['code'] == 3) {
                                DocumentReference docRef = FirebaseFirestore
                                    .instance
                                    .collection("donations")
                                    .doc();
                                DocumentSnapshot docSnap = await docRef.get();
                                var docId2 = docSnap.reference.id;
                                Navigator.pop(context);
                                var newvalue = await Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => WebViews(
                                              txnid: docId2,
                                              productinfo: widget.title!,
                                            )));
                                setState(() {
                                  isClick = false;
                                });
                                print("clicked : $isClick");
                                newvalue == 'Success'
                                    ? Fluttertoast.showToast(
                                        msg: 'Donation made succesfully...')
                                    : newvalue == 'Failed'
                                        ? Fluttertoast.showToast(
                                            msg: 'Donation Failed...')
                                        : newvalue == 'Cancelled'
                                            ? Fluttertoast.showToast(
                                                msg: 'Donation Canceled...')
                                            : null;
                              }
                            },
                      child: Container(
                        height: 65,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                            color: widget.color1,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(children: [
                          Container(
                              width: 60,
                              height: 50,
                              padding: EdgeInsets.symmetric(horizontal: 7),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Image.asset(optn['icon'])),
                          SizedBox(
                            width: 20,
                          ),
                          Text(optn['name']),
                        ]),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 15,
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Future<void> sendTracking({title}) async {
      await UseMixPanel().sendTracking(event: "Clicked on $title in Donations");
    }

    return Container(
      child: InkWell(
          onTap: isClick
              ? null
              : () async {
                  //paymentOptionSheet(context);
                  // DocumentReference doc_ref =
                  //     FirebaseFirestore.instance.collection("donations").doc();
                  // DocumentSnapshot docSnap = await doc_ref.get();
                  // var doc_id2 = docSnap.reference.id;
                  // var newvalue = await Navigator.push(
                  //     context,
                  //     CupertinoPageRoute(
                  //         builder: (context) => WebViews(
                  //               txnid: doc_id2,
                  //               productinfo: widget.title!,
                  //             )));
                  // setState(() {
                  //   isClick = false;
                  // });
                  // newvalue == 'Success'
                  //     ? Fluttertoast.showToast(
                  //         msg: 'Donation made succesfully...')
                  //     : newvalue == 'Failed'
                  //         ? Fluttertoast.showToast(msg: 'Donation Failed...')
                  //         : newvalue == 'Cancelled'
                  //             ? Fluttertoast.showToast(
                  //                 msg: 'Donation Canceled...')
                  //             : null;

                  // Navigator.push(
                  //   context,
                  //   CupertinoPageRoute(
                  //     builder: ((context) => DonateAmount(
                  //         title: title.toString(), image: image.toString(), id: id)),
                  //   ),
                  // );

                  await Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (ctx) => DonateByPaytm(
                                donId: widget.id,
                                donName: widget.title!,
                              )));
                },
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: widget.color2,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 4.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Offer Seva',
                          style: TextStyle(
                              color: widget.color3,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: widget.color3,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: size.width * 0.39,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(
                        10.0,
                      ),
                      child: Image.network(
                        widget.image!,
                        fit: BoxFit.fill,
                        height: 110,
                        width: size.width,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return SizedBox(
                            height: 110,
                            width: size.width,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: widget.loaderColor,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Text(
                      widget.title!,
                      style: TextStyle(fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: widget.color1,
                  // borderRadius: BorderRadius.only(
                  //     topLeft: Radius.circular(20),
                  //     topRight: Radius.circular(20),
                  //     bottomLeft: Radius.circular(20),
                  //     bottomRight: Radius.circular(20)),
                ),
              ),
            ],
          )),
    );
  }
}
