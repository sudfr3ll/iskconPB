// ignore_for_file: sized_box_for_whitespace, prefer_final_fields, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iskcon/screens/Login/OtpPage.dart';
import 'package:iskcon/widgets/Loader.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _textEditingController = TextEditingController();
  String? _verificationCode;
  GlobalKey<FormState> formKey = GlobalKey();
  Future<void> _verifyphone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91 ${_textEditingController.text}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          FocusScope.of(context).unfocus();
          Fluttertoast.showToast(
              msg: "${e.message}",
              timeInSecForIosWeb: 4,
              gravity: ToastGravity.BOTTOM);
        },
        codeSent: (String verificationId, int? resendToken) async {
          // await SmsAutoFill().listenForCode;
          setState(() {
            _verificationCode = verificationId;
          });
          Navigator.pop(context);
          Fluttertoast.showToast(
                  msg: "OTP sent",
                  timeInSecForIosWeb: 4,
                  gravity: ToastGravity.BOTTOM)
              .whenComplete(() async {
            await Future.delayed(Duration(milliseconds: 1000));

            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute(
                builder: (context) => OptPage(
                  number: _textEditingController.text,
                  verificationCode: _verificationCode!,
                ),
              ),
            );
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          _verificationCode = verificationID;
          print('timeout');
        },
        timeout: const Duration(minutes: 1));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/isckon-temple1.png"),
                fit: BoxFit.cover),
          ),
          child: Column(
            children: [
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(119, 21, 190, 0.8),
              //  border: Border(top: BorderSide(color: Colors.amber,width: 2)),
                  border: Border.all(
                      color: Colors.amber, width: 2), // border color
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      topRight: Radius.circular(50.0)),
                ),
                height: size.height * 0.5,
                width: size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.055,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Welcome to our',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall!.merge(
                                TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Punjabi Bagh ISKCON',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall!.merge(
                                TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.1,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Please Sign in to continue',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Container(
                          height: 70,
                          child: TextFormField(
                            maxLength: 10,
                            controller: _textEditingController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              prefix: Text('+91'),
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          )),
                      // SizedBox(
                      //   height: size.height * 0.04,
                      // ),
                      Container(
                        height: 50,
                        width: size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.amber.withValues(alpha: .9),
                            shape: BoxShape.rectangle),
                        child: TextButton(
                            onPressed: () {
                              if (_textEditingController.text.length == 10) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Loader();
                                    });
                                _verifyphone();
                              } else {
                                _textEditingController.text.length != 10
                                    ? Fluttertoast.showToast(
                                        msg: 'Enter the 10 digit number')
                                    : _textEditingController.text.isEmpty
                                        ? Fluttertoast.showToast(
                                            msg: 'Please Enter the number')
                                        : Fluttertoast.showToast(
                                            msg:
                                                'Please Enter the valid number');
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //     SnackBar(
                                //         content:
                                //             Text('Please enter the number')));
                              }
                            },
                            child: Text(
                              'CONTINUE',
                              style: TextStyle(color: Colors.white),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
