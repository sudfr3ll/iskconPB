import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:iskcon/screens/Donate/open_webview_paytm.dart';
import 'package:iskcon/screens/Subscription/SubscriptionWebView.dart';
import 'package:iskcon/widgets/DonationTile.dart';
import 'package:iskcon/widgets/Loader.dart';
import 'package:iskcon/widgets/customAppBar.dart';
import 'package:iskcon/widgets/customShape.dart';
import 'package:iskcon/widgets/webview.dart';

Color primaryColor = Color(0xff9C5AB1);

class DonateByPaytm extends StatefulWidget {
  const DonateByPaytm({
    required this.donId,
    required this.donName,
    this.isSub = false,
    this.amount = 0,
    this.address = '',
    this.email = '',
    this.name = '',
    this.phoneNo = '',
    this.magName = '',
    this.subId = '',
    this.subName = '',
    super.key,
  });

  final String donId;
  final String donName;
  final bool isSub;
  final dynamic amount;
  final String name;
  final String address;
  final String phoneNo;
  final String email;
  final String magName;
  final String subName;
  final String subId;
  @override
  State<DonateByPaytm> createState() => _DonateByPaytmState();
}

class _DonateByPaytmState extends State<DonateByPaytm> {
  List<String> amount = [
    '500',
    '1000',
    '1500',
    '2000',
    '5000',
    '10000',
    '50000',
    '100000',
  ];
  bool loading = false;
  bool isClick = false;
  final FocusNode _amountNode = FocusNode();

  String _getFormat(value) => NumberFormat.currency(
    locale: 'HI',
    symbol: '₹',
    decimalDigits: 0,
  ).format(value);

  String selectedAmount = '';
  Map<String, dynamic> model = {};
  TextEditingController amountController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final _form = GlobalKey<FormState>();

  /*
  Future<void> openPayTm() async {
    setState(() {
      loading = true;
    });
    print('opening paytm...');

    final result1 = await FirebaseFunctions.instance
        .httpsCallable('payments-paytm_getTxnToken')
        .call(
      {
        "amount": double.parse(selectedAmount).toStringAsFixed(2),
      },
    );
    final response0 = result1.data;

    print('response : $response0');

    setState(() {
      loading = false;
    });

    // AllInOneSdk.startTransaction(mid, orderId, amount, txnToken, callbackUrl, isStaging, restrictAppInvoke)
    var response = AllInOneSdk.startTransaction(
        response0['merchantId'],
        response0['donationId'],
        double.parse(selectedAmount).toStringAsFixed(2),
        response0['txnToken'],
        response0['callbackUrl'],
        response0['isStaging'],
        true);
    await response.then((value) {
      print('done');
      print("payment done $value");

      if (widget.isSub) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        // subscriptionSuccess();
      } else {
        Navigator.pop(context);
        // donationPending(docId)
      }

      mySnackBar(context, 'Payment successful');
      // payment done {CURRENCY: INR, GATEWAYNAME: WALLET, RESPMSG: Txn Success, BANKNAME: WALLET, PAYMENTMODE: PPI, MID: RoyalR64432001147100, RESPCODE: 01, TXNAMOUNT: 1.00, TXNID: 20230317010410000843495604533295681, ORDERID: Q5lkLvnrVYFMum6QpyAC, STATUS: TXN_SUCCESS, BANKTXNID: 99944781275535, TXNDATE: 2023-03-17 14:30:23.0, CHECKSUMHASH: xLaersZn1A4SCvnp0FnX+M/cSqj1RpPnIrr1uAXEtwnU9DG33OJ6YJx4X1Q+9dc53Tk4yFnwTuXLlWsb2p53yVJiKLjXjmywAgCYkgQntUc=}
    }).catchError((onError) {
      print('catch error at openPaytm() in donate_by_paytm.dart');
      mySnackBar(context, 'Payment failed');
    });

    print('closing paytm...');
  }

*/
  Future<void> donationPending(docId) async {
    var data = {
      "amount": selectedAmount,
      "createdAt": DateTime.now(),
      "userName": nameController.text,
      "phoneNo": phoneNoController.text,
      "donation": {"id": widget.donId, "name": widget.donName},
      "payment": {"details": {}, "mode": "paytm", "status": "pending"},
    };

    await FirebaseFirestore.instance
        .collection('donations')
        .doc(docId)
        .set(data);
  }

  void paymentOptionSheet(context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          // height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
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
                  const Divider(thickness: 1),
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
                              //openPayTm();
                              openPaytmWebView(context);

                              print("clicked : $isClick");
                            }

                            if (optn['code'] == 2 || optn['code'] == 3) {
                              // Navigator.pop(context);
                              if (widget.isSub) {
                                openCCAvenueForSubscription(context);
                              } else {
                                openCCAvenueForDonation(context);
                              }
                            }
                          },
                    child: Container(
                      height: 65,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 50,
                            padding: EdgeInsets.symmetric(horizontal: 7),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Image.asset(optn['icon']),
                          ),
                          SizedBox(width: 20),
                          Text(optn['name']),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }

  void openPaytmWebView(context) async {
    setState(() {
      loading = true;
      isClick = true;
    });
    String docid = FirebaseFirestore.instance.collection("donations").doc().id;
    if (widget.isSub) {
      await subscriptionPending(docid);
    } else {
      await donationPending(docid);
    }
    Navigator.pop(context);
    var newvalue = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => PaytmWebViews(
          isSub: widget.isSub,
          txnid: docid,
          productinfo: widget.donName,
          amount: selectedAmount,
        ),
      ),
    );

    if (mounted) {
      setState(() {
        isClick = false;
        loading = false;
      });
    }

    print("clicked : $isClick");
    debugPrint('my payment status 2 : $newvalue');
    newvalue == 'Success'
        ? Fluttertoast.showToast(msg: 'Payment succesfully...')
        : newvalue == 'Failed'
        ? Fluttertoast.showToast(msg: 'Payment Failed...')
        : newvalue == 'Cancelled'
        ? Fluttertoast.showToast(msg: 'Payment Canceled...')
        : null;
  }

  void openCCAvenueForSubscription(context) {
    setState(() {
      isClick = true;
      loading = true;
    });
    model['createdAt'] = FieldValue.serverTimestamp();
    model['user'] = {
      'name': widget.name,
      'address': widget.address,
      "phoneNo": widget.phoneNo,
      'email': widget.email,
    };
    model['magazineName'] = widget.magName;

    model['subscription'] = {'id': widget.subId, 'name': widget.subName};
    model['payment'] = {
      'status': 'pending', // completed, failed, cancelled
    };
    showDialog(context: context, builder: (context) => Loader());
    FirebaseFirestore.instance.collection('subscriptions').add(model).then((
      value,
    ) async {
      // Navigator.pop(context);
      var newvalue = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SubscriptionWebView(amount: widget.amount, id: value.id),
        ),
      );
      setState(() {
        isClick = false;
        loading = false;
      });
      Navigator.pop(context);
      Navigator.pop(context);
      newvalue == 'Success'
          ? Fluttertoast.showToast(msg: 'Payment succesfully...')
          : newvalue == 'Failed'
          ? Fluttertoast.showToast(msg: 'Payment Failed...')
          : newvalue == 'Cancelled'
          ? Fluttertoast.showToast(msg: 'Payment Canceled...')
          : null;
    });
  }

  void openCCAvenueForDonation(context) async {
    setState(() {
      loading = true;
    });
    DocumentReference docRef = FirebaseFirestore.instance
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
          productinfo: widget.donName,
          amount: selectedAmount,
        ),
      ),
    );
    setState(() {
      isClick = false;
      loading = false;
    });
    print("clicked : $isClick");
    newvalue == 'Success'
        ? Fluttertoast.showToast(msg: 'Donation made succesfully...')
        : newvalue == 'Failed'
        ? Fluttertoast.showToast(msg: 'Donation Failed...')
        : newvalue == 'Cancelled'
        ? Fluttertoast.showToast(msg: 'Donation Canceled...')
        : null;
  }

  Future<void> subscriptionPending(docId) async {
    var data = {
      "createdAt": DateTime.now(),
      "magazineName": widget.magName,
      "payment": {"details": {}, "mode": "paytm", "status": "pending"},
      "subscription": {"id": widget.subId, "name": widget.subName},
      "user": {
        "address": widget.address,
        "name": widget.name,
        "email": widget.email,
        "phoneNo": widget.phoneNo,
      },
    };

    await FirebaseFirestore.instance
        .collection('subscriptions')
        .doc(docId)
        .set(data);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    if (widget.isSub) {
      amountController.text = _getFormat(double.parse(widget.amount));
      selectedAmount = widget.amount;
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(
          title: widget.isSub ? "Subscription" : "Donate".toUpperCase(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ClipPath(
                      clipper: Customshape(),
                      child: Container(
                        height: 250,
                        decoration: BoxDecoration(color: Colors.amber),
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  ),
                  ClipPath(
                    clipper: Customshape(),
                    child: Container(
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.amber, width: 2),
                        ),
                        image: DecorationImage(
                          image: AssetImage('assets/images/donationBanner.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.amber, width: 2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!widget.isSub)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SizedBox(
                        width: size.width,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty || value.isEmpty) {
                              return 'Enter the last name';
                            } else {
                              return null;
                            }
                          },
                          controller: nameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black12,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black12,
                                width: 2.0,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            filled: true,
                            hintText: 'Enter your name',
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (!widget.isSub) SizedBox(height: 10),
                  if (!widget.isSub)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SizedBox(
                        width: size.width,
                        child: TextFormField(
                          maxLength: 10,
                          controller: phoneNoController,
                          validator: (value) {
                            if (value!.isEmpty || value.isEmpty) {
                              return 'Enter the phone number';
                            } else if (value.length < 10) {
                              return 'Enter the valid phone number';
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black12,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black12,
                                width: 2.0,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            filled: true,
                            hintText: 'Enter your phone',
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (!widget.isSub) SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 23,
                      vertical: 5,
                    ),
                    child: Text(
                      'Amount',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      width: size.width,
                      child: TextFormField(
                        enabled: !widget.isSub,
                        showCursor: true,
                        validator: (value) {
                          if (value!.isEmpty || value.isEmpty) {
                            return 'Enter the amount';
                          } else if (int.parse(
                                value.replaceAll("₹", "").replaceAll(",", ""),
                              ) <
                              10) {
                            return 'Amount should be greater then ₹10.';
                          } else {
                            return null;
                          }
                        },
                        focusNode: _amountNode,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            if (value == "₹") {
                              amountController.text = '';
                            }
                            selectedAmount = value
                                .replaceAll(',', '')
                                .replaceAll('₹', '');
                          });

                          setState(() {
                            amountController.text = _getFormat(
                              double.parse(selectedAmount),
                            );
                            final val = TextSelection.collapsed(
                              offset: amountController.text.length,
                            );
                            amountController.selection = val;
                          });
                        },
                        controller: amountController,
                        // enabled:
                        //     donationAmount.text.isEmpty ? true : false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black12,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black12,
                              width: 2.0,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          filled: true,
                          hintText: 'Enter Custom Amount',
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (!widget.isSub) SizedBox(height: 20),
                ],
              ),
            ),
            if (!widget.isSub)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                  spacing: 5,
                  children: List.generate(amount.length, (index) {
                    bool isSelected = selectedAmount == amount[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedAmount = amount[index]
                              .toString()
                              .replaceAll('₹', '')
                              .replaceAll(',', '');
                          amountController.text = _getFormat(
                            double.parse(amount[index]),
                          );
                        });

                        print("selected amount : $selectedAmount");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Color(0xff9C5AB1)
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        margin: EdgeInsets.all(5),
                        child: Text(
                          _getFormat(int.parse(amount[index])),
                          style: TextStyle(
                            color: isSelected ? Colors.white : null,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 50,
                width: size.width * 0.9,
                // decoration: BoxDecoration(
                //     color: primaryColor,
                //     borderRadius: BorderRadius.circular(20)),
                margin: EdgeInsets.all(20),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: loading
                        ? primaryColor.withValues(alpha: 0.5)
                        : selectedAmount
                              .replaceAll('₹', '')
                              .replaceAll(',', '')
                              .isEmpty
                        ? Colors.grey.shade300
                        : primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed:
                      selectedAmount
                          .replaceAll('₹', '')
                          .replaceAll(',', '')
                          .isEmpty
                      ? null
                      : () {
                          bool isValidate = _form.currentState!.validate();

                          if (isValidate) {
                            _amountNode.unfocus();
                            // subscriptionSuccess();
                            //openPayTm();
                            paymentOptionSheet(context);
                          }
                        },
                  child: Text(
                    loading
                        ? "PLEASE WAIT..."
                        : widget.isSub
                        ? 'PAY NOW'
                        : 'DONATE NOW',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> mySnackBar(
  context,
  message,
) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      clipBehavior: Clip.antiAlias,
      duration: const Duration(seconds: 5),
      backgroundColor: primaryColor.withValues(alpha: 0.8),
      content: Text(message),
    ),
  );
}
