import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iskcon/screens/Donate/donate_by_paytm.dart';
import 'package:iskcon/screens/Subscription/SubscriptionWebView.dart';
import 'package:iskcon/widgets/DonationTile.dart';
import 'package:iskcon/widgets/Loader.dart';
import 'package:iskcon/widgets/customAppBar.dart';

class SubscriptionStep3 extends StatefulWidget {
  final String docId;
  final String name;
  final String amount;
  final String magazineName;
  const SubscriptionStep3(
      {super.key,
      required this.docId,
      required this.name,
      required this.amount,
      required this.magazineName});

  @override
  State<SubscriptionStep3> createState() => _SubscriptionStep3State();
}

class _SubscriptionStep3State extends State<SubscriptionStep3> {
  final _formKey = GlobalKey<FormState>();
  bool isClick = false;
  Map<String, dynamic> model = <String, dynamic>{};
  TextEditingController nameController = TextEditingController();
  TextEditingController addressControler = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController emailController = TextEditingController();

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
                                              donId: "",
                                              donName: "",
                                              amount: widget.amount,
                                              isSub: true,
                                              name: nameController.text,
                                              address: addressControler.text,
                                              email: emailController.text,
                                              phoneNo: phoneNumber.text,
                                              subName: widget.name,
                                              magName: widget.magazineName,
                                              subId: widget.docId,
                                            )));
                                setState(() {
                                  isClick = false;
                                });
                                print("clicked : $isClick");
                              }

                              if (optn['code'] == 2 || optn['code'] == 3) {
                                openCCAvenue();
                              }
                            },
                      child: Container(
                        height: 65,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.1),
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

  void openCCAvenue() {
    setState(() {
      isClick = true;
    });
    model['createdAt'] = FieldValue.serverTimestamp();
    model['user'] = {
      'name': nameController.text,
      'address': addressControler.text,
      "phoneNo": phoneNumber.text,
      'email': emailController.text,
    };
    model['magazineName'] = widget.magazineName;

    model['subscription'] = {
      'id': widget.docId,
      'name': widget.name,
    };
    model['payment'] = {
      'status': 'pending' // completed, failed, cancelled
    };
    showDialog(context: context, builder: (context) => Loader());
    FirebaseFirestore.instance
        .collection('subscriptions')
        .add(model)
        .then((value) async {
      Navigator.pop(context);
      var newvalue = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SubscriptionWebView(
                    amount: widget.amount,
                    id: value.id,
                  )));
      setState(() {
        isClick = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: CustomAppBar(title: 'Your Information')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step 2 of 2',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .merge(TextStyle(fontFamily: 'Lexend')),
                ),
                SizedBox(
                  height: 10,
                ),
                customFormField(
                    label: 'First Name',
                    controller: nameController,
                    validator: (value) {
                      if (nameController.text.isEmpty) {
                        return 'Enter the Name';
                      }
                      return null;
                    }),
                SizedBox(
                  height: 10,
                ),
                customFormField(
                    label: 'Address',
                    maxLine: 5,
                    controller: addressControler,
                    validator: (value) {
                      if (addressControler.text.isEmpty) {
                        return 'Enter the Address';
                      }
                      return null;
                    }),
                SizedBox(
                  height: 10,
                ),
                customFormField(
                    label: 'Phone Number',
                    textInputType: TextInputType.phone,
                    controller: phoneNumber,
                    maxLength: 10,
                    validator: (value) {
                      if (phoneNumber.text.isEmpty) {
                        return 'Enter Phone Number';
                      } else if (phoneNumber.text.length < 10) {
                        return 'Please Enter 10 Digit Number';
                      }
                      return null;
                    }),
                SizedBox(
                  height: 10,
                ),
                customFormField(
                    label: 'Email',
                    controller: emailController,
                    textInputType: TextInputType.emailAddress,
                    validator: (value) {
                      final pattern =
                          r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$';
                      final regex = RegExp(pattern);
                      if (emailController.text.isEmpty) {
                        return 'Enter the Email';
                      } else if (!regex.hasMatch(value!)) {
                        return 'Enter the valid email';
                      } else {
                        return null;
                      }
                    }),
                SizedBox(
                  height: 10,
                ),
                Text('Note: Your first issue will arrive in 4-5 weeks.'),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Color(0xff9C5AB1),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            size: 20,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Previous',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Color(0xff9C5AB1),
                      ),
                      onPressed: isClick
                          ? null
                          : () async {
                              // if (_formKey.currentState!.validate()) {
                              //   paymentOptionSheet(context);
                              // }
                              if (_formKey.currentState!.validate()) {
                                await Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (ctx) => DonateByPaytm(
                                              donId: "",
                                              donName: "",
                                              amount: widget.amount.toString(),
                                              isSub: true,
                                              name: nameController.text,
                                              address: addressControler.text,
                                              email: emailController.text,
                                              phoneNo: phoneNumber.text,
                                              subName: widget.name,
                                              magName: widget.magazineName,
                                              subId: widget.docId,
                                            )));
                              }
                            },
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            'Next',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customFormField(
      {label,
      TextInputType textInputType = TextInputType.name,
      maxLine,
      TextEditingController? controller,
      int? maxLength,
      String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      maxLines: maxLine,
      maxLength: maxLength,
      validator: validator,
      decoration: InputDecoration(
          hintText: label,
          // label: label == null ? SizedBox() : Text(label),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black12,
              ),
              borderRadius: BorderRadius.circular(10)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
              ),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black12,
              ),
              borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black12,
              ),
              borderRadius: BorderRadius.circular(10))),
    );
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
