// ignore_for_file: prefer_is_empty, prefer_collection_literals

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iskcon/constants/databaseService.dart';

Map<String, dynamic> model = Map<String, dynamic>();

class EnquiryForm extends StatefulWidget {
  const EnquiryForm({super.key});

  @override
  State<EnquiryForm> createState() => _EnquiryFormState();
}

class _EnquiryFormState extends State<EnquiryForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Name',
                style: TextStyle(color: Colors.black54),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
              ),
              TextFormField(
                controller: name,
                // onSaved: (value) {
                //   setState(() {
                //     name = value;
                //   });
                // },
                validator: (value) {
                  if (value!.isEmpty || value.length == 0) {
                    return 'Enter the name';
                  } else {
                    return null;
                  }
                },
                enabled: true,
                decoration: InputDecoration(
                    hintText: 'Enter your name',
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black26,
                        ),
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(
                height: 10,
              ),
              Text('Email Address', style: TextStyle(color: Colors.black54)),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
              ),
              TextFormField(
                controller: email,
                // onSaved: (value) {
                //   setState(() {
                //     email = value;
                //   });
                // },
                validator: (value) {
                  String pattern =
                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                      r"{0,253}[a-zA-Z0-9])?)*$";
                  RegExp regex = RegExp(pattern);
                  if (value!.isEmpty || value.length == 0) {
                    return 'Enter the email';
                  } else if (!regex.hasMatch(value)) {
                    return 'Enter the valid email';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                    hintText: 'Enter your email address',
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black26,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(
                height: 10,
              ),
              Text('Phone Number', style: TextStyle(color: Colors.black54)),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
              ),
              TextFormField(
                maxLength: 10,
                controller: phoneNumber,
                // onSaved: (value) {
                //   setState(() {
                //     phoneNumber = value;
                //   });
                // },
                validator: (value) {
                  if (value!.isEmpty || value.length == 0) {
                    return 'Enter the phone number';
                  } else if (value.length < 10) {
                    return 'Enter the valid phone number';
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: 'Enter your phone number',
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black26,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(
                height: 10,
              ),
              Text('Message', style: TextStyle(color: Colors.black54)),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
              ),
              TextFormField(
                controller: message,
                // onSaved: (value) {
                //   setState(() {
                //     message = value;
                //   });
                // },
                validator: (value) {
                  if (value!.isEmpty || value.length == 0) {
                    return 'Enter the message';
                  } else {
                    return null;
                  }
                },
                maxLines: 5,
                decoration: InputDecoration(
                    hintText: 'Enter your message',
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black26,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    gradient: LinearGradient(colors: [
                      Color(0xff9C5AB1),
                      Color(0xff9C5AB1),

                      // Color.fromRGBO(192, 175, 233, 1),
                      // Color.fromRGBO(119, 97, 172, 1),
                    ])),
                child: TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          name.text.isNotEmpty &&
                          email.text.isNotEmpty &&
                          phoneNumber.text.isNotEmpty &&
                          message.text.isNotEmpty) {
                        print('name:${name.text}');
                        print('email:${email.text}');
                        print('phoneNumber:${phoneNumber.text}');
                        print('message:${message.text}');
                        setState(() {
                          model['name'] = name.text;
                          model['email'] = email.text;
                          model['phone'] = phoneNumber.text;
                          model['message'] = message.text;
                          model['createdAt'] = FieldValue.serverTimestamp();
                        });
                        showDialog(
                            context: context,
                            builder: (context) => Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      color: Color(0xff9C5AB1),
                                      // Colors.purple,
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      'Loading...',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ));
                        DataBaseSerice().enquiryForm(model).whenComplete(() {
                          // setState(() {
                          //   name.clear();
                          //   email.clear();
                          //   phoneNumber.clear();
                          //   message.clear();
                          // });
                          _formKey.currentState!.reset();
                          name.clear();
                          email.clear();
                          phoneNumber.clear();
                          message.clear();
                          Fluttertoast.showToast(msg: 'Thanks for enquiry');
                          Navigator.pop(context);
                        });
                      }
                    },
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              // Container(
              //   child: TextButton(
              //       style: TextButton.styleFrom(
              //           backgroundColor: Color.fromRGBO(242, 196, 6, 1),
              //           shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(5))),
              //       onPressed: () {
              //         if (_formKey.currentState!.validate() &&
              //             name.text.isNotEmpty &&
              //             email.text.isNotEmpty &&
              //             phoneNumber.text.isNotEmpty &&
              //             message.text.isNotEmpty) {
              //           print('name:${name.text}');
              //           print('email:${email.text}');
              //           print('phoneNumber:${phoneNumber.text}');
              //           print('message:${message.text}');
              //           setState(() {
              //             model['name'] = name.text;
              //             model['email'] = email.text;
              //             model['phone'] = phoneNumber.text;
              //             model['message'] = message.text;
              //             model['createdAt'] = FieldValue.serverTimestamp();
              //           });
              //           showDialog(
              //               context: context,
              //               builder: (context) => Column(
              //                     mainAxisAlignment: MainAxisAlignment.center,
              //                     children: [
              //                       CircularProgressIndicator(
              //                         color: Colors.purple,
              //                       ),
              //                       SizedBox(
              //                         height: 4,
              //                       ),
              //                       Text(
              //                         'Loading...',
              //                         style: TextStyle(color: Colors.white),
              //                       )
              //                     ],
              //                   ));
              //           DataBaseSerice().enquiryForm(model).whenComplete(() {
              //             // setState(() {
              //             //   name.clear();
              //             //   email.clear();
              //             //   phoneNumber.clear();
              //             //   message.clear();
              //             // });
              //             _formKey.currentState!.reset();
              //             name.clear();
              //             email.clear();
              //             phoneNumber.clear();
              //             message.clear();
              //             Fluttertoast.showToast(msg: 'Thanks for enquiry');
              //             Navigator.pop(context);
              //           });
              //         }
              //       },
              //       child: Text(
              //         'SUBMIT',
              //         style: TextStyle(
              //           color: Colors.white,
              //         ),
              //       )),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
