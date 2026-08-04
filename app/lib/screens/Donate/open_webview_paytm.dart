import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:iskcon/constants/provider.dart';
import 'package:iskcon/widgets/customAppBar.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaytmWebViews extends StatefulWidget {
  final String? merchId;
  final String? txnid;
  final String? productinfo;
  final String? amount;
  final bool isSub;

  const PaytmWebViews({
    super.key,
    this.merchId,
    this.txnid,
    this.productinfo,
    this.amount,
    required this.isSub,
  });

  @override
  State<PaytmWebViews> createState() => _PaytmWebViewsState();
}

class _PaytmWebViewsState extends State<PaytmWebViews> {
  WebViewController? webViewController;
  final TextEditingController _textEditingController = TextEditingController();

  // Future<PaypayLoad>? payload;
  double progress = 0;
  String paymentMode = '';

  @override
  void initState() {
    print('Merch Id ${widget.merchId}');
    print('TxnId is : ${widget.txnid}');
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppState>(context);
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: CustomAppBar(
                  title: widget.isSub ? 'Subscription' : 'Donation')),
          body: Column(children: [
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri(
                    widget.isSub
                        ? 'https://bwi-iskon-payment.web.app/subscriptionPage?docId=${widget.txnid}&amount=${widget.amount}&mode=paytm'
                        : 'https://bwi-iskon-payment.web.app/paymentPage?dId=${widget.txnid}&dType=${widget.productinfo}&dAmount=${widget.amount}&mode=paytm',
                  ),
                ),
                onWebViewCreated: (controller) {
                  print(controller.getUrl());
                },
                onExitFullscreen: (controller) async {
                  var url = await controller.getUrl();
                  debugPrint('exit url : $url');
                  Navigator.pop(context, 'Cancelled');
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

                onConsoleMessage: (controller, consoleMessage) {
                  print('Successs: $consoleMessage This the success reques');
                },
                onUpdateVisitedHistory: (controller, Uri? uri, bool? trfl) {
                  debugPrint("updated bool : $trfl");
                  debugPrint("updated url : $uri");
                  if (uri.toString().contains('paytm-success') ||
                      uri.toString().contains('paytmCallback?ORDER_ID')) {
                    debugPrint('my payment status 0: Success');
                    if (widget.isSub) {
                      Navigator.pop(context, 'Success');
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context, 'Success');
                      Navigator.pop(context);
                    }
                  }
                  if (uri.toString().contains('paytm-failure')) {
                    debugPrint('my payment status 1: Failed');
                    print('Pyament is Failed.....');
                    Navigator.of(context).pop('Failed');
                  }
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
