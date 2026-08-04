// ignore_for_file: use_build_context_synchronously, unused_element, no_leading_underscores_for_local_identifiers, unused_local_variable

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iskcon/constants/databaseService.dart';
import 'package:iskcon/routes/routes_view.dart';
import 'package:iskcon/widgets/Loader.dart';
import 'package:pinput/pinput.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OptPage extends StatefulWidget {
  final String number;
  final String verificationCode;
  const OptPage(
      {super.key, required this.number, required this.verificationCode});

  @override
  State<OptPage> createState() => _OptPageState();
}

class _OptPageState extends State<OptPage> {
  final _auth = FirebaseAuth.instance;
  int start = 59;
  bool wait = false;
  List isSelecteds = [];
  List deviceToken = [];
  var duration = Duration(seconds: 29);
  bool timeout = false;
  bool enableButton = false;
  String? _verificationCode;

  bool isLoggedIn = false;

  final TextEditingController _pinPutController = TextEditingController();
  Future<void> _verifyphone() async {
    await FirebaseAuth.instance
        .verifyPhoneNumber(
            phoneNumber: '+91 ${widget.number}',
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
              Fluttertoast.showToast(
                  msg: "OTP sent",
                  timeInSecForIosWeb: 4,
                  gravity: ToastGravity.BOTTOM);
              // await SmsAutoFill().listenForCode;
              setState(() {
                _verificationCode = verificationId;
                wait = false;
                start = 59;
                startTimer();
              });
            },
            codeAutoRetrievalTimeout: (String verificationID) {
              _verificationCode = verificationID;
              print('timeout');
            },
            timeout: const Duration(seconds: 59))
        .whenComplete(() {});
  }

  void startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (start > 0) {
        setState(() {
          start--;
        });
      } else {
        setState(() {
          timer.cancel();
          wait = true;
        });
      }
      print(start);
    });
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
              ),
              Text(
                'OTP Verification',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .merge(TextStyle(fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 5,
              ),
              Text('We have just sent a code to ',
                  style: TextStyle(color: Colors.black54)),
              SizedBox(
                height: 5,
              ),
              Text('+91 ${widget.number.replaceRange(0, 6, '******')}',
                  style: TextStyle(color: Colors.black54)),
              SizedBox(
                height: size.height * 0.1,
              ),
              Center(
                child: Pinput(
                  length: 6,
                  controller: _pinPutController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  defaultPinTheme: PinTheme(
                    height: 50.0,
                    width: 50.0,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    textStyle: GoogleFonts.urbanist(
                      fontSize: 24.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white12,
                        border: Border.all(
                          color: Colors.black12,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  focusedPinTheme: PinTheme(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    height: 50.0,
                    width: 50.0,
                    textStyle: GoogleFonts.urbanist(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white12,
                        border: Border.all(
                          color: Colors.black12,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onChanged: (a) {
                    if (_pinPutController.text.length == 6) {
                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: _verificationCode.toString(),
                              smsCode: _pinPutController.text);
                      FirebaseAuth.instance.signInWithCredential(credential);
                    }
                  },
                  enabled: true,
                  pinAnimationType: PinAnimationType.scale,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter OTP';
                    }
                    return null;
                  },
                  // onSubmit: (pin) async {
                  //   setState(() {
                  //     otpPin = pin;
                  //   });
                  //   FocusScope.of(context).unfocus();
                  //   // signInWithCredentials(otpPin);
                  // },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: wait == false
                      ? InkWell(
                          onTap: null,
                          child: Text('00:$start',
                              style: TextStyle(color: Colors.black54)),
                        )
                      : Wrap(
                          children: [
                            Text('Didn\'t receive the code? ',
                                style: TextStyle(color: Colors.black54)),
                            InkWell(
                              onTap: () {
                                if (wait == true) {
                                  setState(() {
                                    _verifyphone();
                                  });
                                }
                              },
                              child: Text(
                                'Resend Code',
                                style: TextStyle(color: Colors.purple),
                              ),
                            )
                          ],
                        ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 50,
                width: size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.amber.withValues(alpha: .9),
                    shape: BoxShape.rectangle),
                child: TextButton(
                    onPressed: () async {
                      if (_pinPutController.text.length == 6) {
                        try {
                          SharedPreferences _prefs =
                              await SharedPreferences.getInstance();

                          PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: widget.verificationCode,
                                  smsCode: _pinPutController.text);

                          final user =
                              await _auth.signInWithCredential(credential);
                          showDialog(
                            context: context,
                            builder: (context) => Loader(),
                          );

                          final checkUser =
                              await DataBaseSerice().checkUser(user.user!.uid);
                          setState(() {
                            isLoggedIn = true;
                          });
                          if (checkUser.exists) {
                            _prefs.setString('phoneNumber', widget.number);
                            _prefs.setBool('isLoggedIn', true);
                            Timer(Duration(seconds: 3),
                                () => Navigator.pop(context));

                            Timer(
                                Duration(seconds: 3),
                                () => Navigator.of(context)
                                    .pushNamedAndRemoveUntil(RoutesView.HOME,
                                        (Route<dynamic> route) => false));
                          } else {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.user!.uid)
                                .set({'phoneNumber': widget.number},
                                    SetOptions(merge: true));
                            showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (context) {
                                  return Container(
                                    height: size.height * 0.55,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(30),
                                            topLeft: Radius.circular(30))),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Image.asset('assets/images/done.png'),
                                          Text(
                                            'Success!',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall!
                                                .merge(TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            'You have successfully created',
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                          Text('your account',
                                              style: TextStyle(
                                                  color: Colors.black54)),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: Container(
                                              height: 50,
                                              width: size.width,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.amber
                                                      .withValues(alpha: .9),
                                                  shape: BoxShape.rectangle),
                                              child: TextButton(
                                                  onPressed: () {
                                                    Loader();
                                                    Navigator.of(context)
                                                        .pushNamedAndRemoveUntil(
                                                            RoutesView.HOME,
                                                            (Route<dynamic>
                                                                    route) =>
                                                                false);
                                                    // Navigator.push(
                                                    //     context,
                                                    //     CupertinoPageRoute(
                                                    //         builder: (context) =>
                                                    //             CustomBottomNavBar()));
                                                    _prefs.setString(
                                                        'phoneNumber',
                                                        widget.number);
                                                    _prefs.setBool(
                                                        'isLoggedIn', true);
                                                  },
                                                  child: Text(
                                                    'Welcome to Punjabi Bagh ISKCON',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          }
                        } on Exception catch (e) {
                          Fluttertoast.showToast(msg: '$e');
                        }
                      }
                    },
                    child: Text(
                      'Verify and Proceed',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              SizedBox(
                height: 30,
              ),
              Align(
                  child: Text('By Signup, you agree to our',
                      style: TextStyle(color: Colors.black54))),
              Align(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    InkWell(
                        onTap: () {},
                        child: Text(
                          'Terms ',
                          style: TextStyle(color: Colors.purple),
                        )),
                    Text('and ', style: TextStyle(color: Colors.black54)),
                    InkWell(
                        onTap: () {},
                        child: Text(
                          'Condition',
                          style: TextStyle(color: Colors.purple),
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
