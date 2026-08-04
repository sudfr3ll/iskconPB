import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:iskcon/constants/provider.dart';
import 'package:iskcon/models/PayU_Payload.dart';
import 'package:iskcon/widgets/customAppBar.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SubscriptionWebView extends StatefulWidget {
  final String id;
  final String amount;
  const SubscriptionWebView({
    super.key,
    required this.id,
    required this.amount,
  });

  @override
  State<SubscriptionWebView> createState() => _SubscriptionWebViewState();
}

class _SubscriptionWebViewState extends State<SubscriptionWebView> {
  WebViewController? webViewController;
  final TextEditingController _textEditingController = TextEditingController();
  Future<PaypayLoad>? payload;
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppState>(context);
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: CustomAppBar(title: 'Subscription')),
          body: Column(children: [
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri(
                    'https://bwi-iskon-payment.web.app/subscriptionPage?docId=${widget.id}&amount=${widget.amount}&mode=ccAvenue',
                  ),
                ),
                onWebViewCreated: (controller) {
                  print(controller.getUrl());
                },
                onExitFullscreen: (controller) {
                  Navigator.of(context).pop('Cancel');
                },
                onLoadStart: ((controller, url) {
                  setState(() {
                    _textEditingController.text = url.toString();
                  });
                  controller.isLoading().whenComplete(() {
                    Future.delayed(Duration(seconds: 10), () {
                      print('This is : $url/products');
                    });
                  });
                }),
                onLoadStop: (controller, url) {
                  controller.postWebMessage(
                      message: WebMessage(data: 'Successfull'));
                },
                onTitleChanged: ((controller, title) async {
                  print('Url is : $title');
                  var urs = controller.getUrl();
                  print(controller.getUrl());

                  if (title.toString().contains('hdfcRedirectLink')) {
                    await urs.then((value) {
                      FirebaseFirestore.instance
                          .collection('subscriptions')
                          .doc(value!.queryParameters['orderId'])
                          .get()
                          .then((DocumentSnapshot value) {
                        dynamic paymentData = value.data();
                        print('Payment Initialted.....');
                        if (paymentData['payment']['status'] == 'completed') {
                          Timer(Duration(seconds: 4), () {
                            Navigator.of(context).pop('Success');
                          });
                        } else if (paymentData['payment']['status'] ==
                                'pending' ||
                            paymentData['payment']['status'] == 'failed') {
                          Timer(Duration(seconds: 4), () {
                            Navigator.of(context).pop('Failed');
                          });
                        } else if (paymentData['payment']['status'] ==
                            'cancelled') {
                          print('Pyament is Cancelled.....');

                          Timer(Duration(seconds: 4), () {
                            Navigator.of(context).pop('Cancelled');
                          });
                        }
                      });
                    });
                    // provider.changeDonationStatus();
                  }
                  if (title.toString().contains('hdfcCancelLink')) {
                    print('Pyament is Failed.....');
                    Timer(Duration(seconds: 4), () {
                      Navigator.of(context).pop('Failed');
                    });
                  }
                }),
                onConsoleMessage: (controller, consoleMessage) {
                  print('Successs: $consoleMessage This the success reques');
                },
                onProgressChanged:
                    (InAppWebViewController controller, int progress) {
                  setState(() {
                    this.progress = progress / 100;
                  });
                },
              ),
            ),
          ])),
    );
  }
}
