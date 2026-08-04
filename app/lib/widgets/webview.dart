import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:iskcon/models/PayU_Payload.dart';
import 'package:iskcon/widgets/customAppBar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViews extends StatefulWidget {
  final String? merchId;
  final String? txnid;
  final String? productinfo;
  // final String? amount;
  final String? firstname;
  final String? lastname;
  final String? phone;
  final String? email;
  final String? amount;
  final String? hash;
  final String? furl;
  final String? surl;
  final String? curl;
  final String? salt;
  final String? docId;
  const WebViews(
      {super.key,
      this.merchId,
      this.txnid,
      this.productinfo,
      this.firstname,
      this.lastname,
      this.phone,
      this.email,
      this.amount,
      this.hash,
      this.furl,
      this.surl,
      this.curl,
      this.salt,
      this.docId});

  @override
  State<WebViews> createState() => _WebViewsState();
}

class _WebViewsState extends State<WebViews> {
  WebViewController? webViewController;
  final TextEditingController _textEditingController = TextEditingController();
  Future<PaypayLoad>? payload;
  double progress = 0;

  @override
  void initState() {
    print('Merch Id ${widget.merchId}');
    print('TxnId is : ${widget.txnid}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: CustomAppBar(title: 'Donation')),
          body: Column(children: [
            // TextField(
            //   controller: _textEditingController,
            //   enabled: false,
            //   scrollPhysics: PageScrollPhysics(),
            //   scrollController: _scrollController,
            //   decoration: InputDecoration(
            //       contentPadding: EdgeInsets.symmetric(horizontal: 8)),
            //   style: TextStyle(color: Colors.grey),
            // ),
            //     Expanded(
            //       child: InAppWebView(
            //         initialUrlRequest: URLRequest(
            //             url: Uri.parse('https://www.iskconpunjabibagh.com/donate/')),
            //         onLoadStart: ((controller, url) {
            //           _textEditingController.text = url.toString();
            //         }),
            //       ),
            //     ),
            //   ],
            // )
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri(
                    'https://bwi-iskon-payment.web.app/paymentPage?dId=${widget.txnid}&dType=${widget.productinfo}&dAmount=${widget.amount}&mode=ccAvenue',
                  ),
                  // method: 'POST',
                  // body: Uint8List.sfromList(utf8.encode(
                  //     'key=${widget.merchId}&txnid=${widget.txnid}&amount=${widget.amount}'
                  //     '&productinfo=${widget.productinfo}&firstname=${widget.firstname}&lastname=${widget.lastname}&email=${widget.email}&phone=${widget.phone}&hash=${widget.hash}&surl=${widget.surl}&furl=${widget.furl}&curl=${widget.curl}'))
                ),
                onWebViewCreated: (controller) {
                  print(controller.getUrl());
                  // controller.printCurrentPage();
                  // print(controller.getUrl());
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
                          .collection('donations')
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
                  // else {

                  // }
                  // if (title.toString().contains('Fail')) {
                  //   // provider.changeDonationStatus();
                  //   Timer(Duration(seconds: 5), () {
                  //     Navigator.of(context).pop('Fail');
                  //   });
                  // }
                  // if (title.toString().contains('Cancel')) {
                  //   // provider.changeDonationStatus();
                  //   Timer(Duration(seconds: 5), () {
                  //     Navigator.of(context).pop('Cancel');
                  //   });
                  // }

                  // print('$title a;adjf;ajsd;f;sladfj;lasdf;lsd;lf;lkjf');
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

                // javascriptChannels: <JavascriptChannel>{
                //   JavascriptChannel(
                //     name: 'messageHandler',
                //     onMessageReceived: (JavascriptMessage message) {
                //       const script = "document.getElementById('paymentSubmit')";
                //       _webViewController?.runJavascript(script);
                //     },
                //   )
                // },
                // onWebViewCreated: (WebViewController webViewController) async {
                //   _webViewController = webViewController;
                //   String fileContent =
                //       await rootBundle.loadString('assets/images/index.html');
                //   _webViewController?.loadUrl(Uri.dataFromString(fileContent,
                //           mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
                //       .toString());
                //   // _webViewController!.loadRequest(WebViewRequest(
                //   //   uri: Uri.parse('https://test.payu.in/_payment'),
                //   //   method: WebViewRequestMethod.post,
                //   // ));
                // },
              ),
            ),
          ])),
    );
  }
}
