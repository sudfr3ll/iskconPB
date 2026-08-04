// ignore_for_file: no_leading_underscores_for_local_identifiers, sized_box_for_whitespace, prefer_final_fields, prefer_collection_literals, prefer_is_empty

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iskcon/widgets/customShape.dart';
import 'package:iskcon/widgets/webview.dart';

Map<String, dynamic> model = Map<String, dynamic>();

class DonateAmount extends StatefulWidget {
  final String title;
  final String? image;
  final String? id;
  const DonateAmount({super.key, required this.title, this.image, this.id});

  @override
  State<DonateAmount> createState() => _DonateAmountState();
}

class _DonateAmountState extends State<DonateAmount> {
  bool isLoading = false;

  String? hash;
  String? curl;
  String? furl;
  String? surl;
  String? txnId;
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController donationAmount = TextEditingController();

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
  int? _selectedIndex;
  String? merchId;
  String? salt;
  Future<void> callFunction(firstName, lastName, email, phoneNumber, amount) async {
    try {
      HttpsCallable callable = FirebaseFunctions.instance
          .httpsCallable('payments-generateSHA512Response');
      model['key'] = merchId;
      model['docId'] = widget.id;
      model['productinfo'] = widget.title;
      model['firstname'] = firstName;
      model['lastname'] = lastName;
      model['phone'] = phoneNumber;
      model['email'] = email;
      model['amount'] = double.parse(amount).toDouble().toString();
      final results = await callable.call(model);
      if (results.data['status'] == false) {
        Fluttertoast.showToast(
            msg: 'We are facing some issue! Please try again later.');
      } else {
        setState(() {
          hash = results.data['hash'];
          surl = results.data['redirectURL']['surl'];
          curl = results.data['redirectURL']['curl'];
          furl = results.data['redirectURL']['furl'];
          txnId = results.data['txnId'];
        });
        print(hash);
        print(curl);
        print(surl);
        print(furl);
        // ignore: use_build_context_synchronously
        var newvalue = await Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => WebViews(
                    amount: double.parse(amount).toDouble().toString(),
                    email: email.toString(),
                    firstname: firstName.toString(),
                    lastname: lastName.toString(),
                    merchId: merchId!.toString(),
                    phone: phoneNumber,
                    productinfo: widget.title,
                    txnid: txnId.toString(),
                    docId: widget.id.toString(),
                    hash: hash.toString().toLowerCase(),
                    curl: curl.toString(),
                    furl: furl.toString(),
                    surl: surl.toString(),
                    salt: salt!)));

        newvalue == 'Success'
            ? Fluttertoast.showToast(msg: 'Donation made succesfully...')
            : newvalue == 'Fail'
                ? Fluttertoast.showToast(msg: 'Donation Failed...')
                : newvalue == 'Cancel'
                    ? Fluttertoast.showToast(msg: 'Donation Canceled...')
                    : null;

        print(model);
        print('Salt $salt');
        print('Surl $surl');
      }

      print(results.data);
    } on FirebaseFunctionsException catch (error) {
      print(error.message);
    }
  }

  Future<void> getMerchantId() async {
    await FirebaseFirestore.instance
        .collection('Integrations')
        .doc('PayU')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        merchId = documentSnapshot.get('credentials.merchantId');
        salt = documentSnapshot.get('credentials.SALT');
      });
      print(merchId);
    });
  }

  @override
  void initState() {
    super.initState();
    getMerchantId();
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 46,
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          Image.asset('assets/images/logo2.png'),
        ],
      ),
      body: Container(
        height: _size.height,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ClipPath(
                          clipper: Customshape(),
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(color: Colors.amber
                                // image: DecorationImage(
                                //     image: NetworkImage(
                                //         "https://w0.peakpx.com/wallpaper/687/933/HD-wallpaper-iskcon-bengaluru-iskon-karnataka-temple-thumbnail.jpg"),
                                //     fit: BoxFit.cover),
                                ),
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                      ),
                      ClipPath(
                        clipper: Customshape(),
                        child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.amber, width: 2)),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "https://w0.peakpx.com/wallpaper/687/933/HD-wallpaper-iskcon-bengaluru-iskon-karnataka-temple-thumbnail.jpg"),
                                  fit: BoxFit.cover),
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.amber, width: 2)),
                                color: Color.fromRGBO(112, 5, 195, .6),
                              ),
                            )),
                      ),
                      Positioned(
                        left: _size.width * 0.3,
                        top: 80,
                        child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.white, width: 2)),
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Image.network(
                            widget.image!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Container(
                      width: _size.width,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty || value.length == 0) {
                            return 'Enter the first name';
                          } else {
                            return null;
                          }
                        },
                        controller: firstName,
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
                          )),
                          filled: true,
                          hintText: 'Enter your first name',
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Container(
                      width: _size.width,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty || value.length == 0) {
                            return 'Enter the last name';
                          } else {
                            return null;
                          }
                        },
                        controller: lastName,
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
                          )),
                          filled: true,
                          hintText: 'Enter your last name',
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Container(
                      width: _size.width,
                      child: TextFormField(
                        maxLength: 10,
                        controller: phoneNumber,
                        validator: (value) {
                          if (value!.isEmpty || value.length == 0) {
                            return 'Enter the phone number';
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
                          )),
                          filled: true,
                          hintText: 'Enter your phone',
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Container(
                      width: _size.width,
                      child: TextFormField(
                        controller: email,
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
                          )),
                          filled: true,
                          hintText: 'Enter your email',
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      )),
                ),
                // Text(
                //   'Choose the amount you want to donate',
                //   style: Theme.of(context)
                //       .textTheme
                //       .titleLarge
                //       .merge(TextStyle(fontSize: 14)),
                // ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Container(
                      width: _size.width,
                      child: TextFormField(
                        showCursor: true,
                        validator: (value) {
                          if (value!.isEmpty || value.length == 0) {
                            return 'Enter the amount';
                          } else {
                            return null;
                          }
                        },
                        controller: donationAmount,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          if (_selectedIndex != null) {
                            setState(() {
                              _selectedIndex = null;
                            });
                          }
                        },
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
                          )),
                          filled: true,
                          hintText: 'Enter Custom Amount',
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Wrap(
                    spacing: 5,
                    children: List.generate(
                        amount.length,
                        (index) => Container(
                              width: 88,
                              child: ChoiceChip(
                                shadowColor: Colors.amber.shade700,
                                elevation: _selectedIndex == index ? 2 : null,
                                selectedColor: Colors.amber,
                                onSelected: (bool selected) {
                                  setState(() {
                                    if (selected) {
                                      _selectedIndex = index;
                                      donationAmount.text =
                                          amount[_selectedIndex!].toString();
                                    }
                                  });
                                  print(_selectedIndex);
                                  print(amount[_selectedIndex!]);
                                },
                                label: Text(
                                  '₹${amount[index]}',
                                  style: TextStyle(
                                    color: _selectedIndex == index
                                        ? Colors.white
                                        : null,
                                  ),
                                ),
                                selected: _selectedIndex == index,
                              ),
                            )).toList(),
                  ),
                ),
                SizedBox(
                  height: _size.height * 0.1,
                ),
                Container(
                  width: _size.width * 0.7,
                  height: _size.width * 0.12,
                  child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Color.fromRGBO(242, 196, 6, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      onPressed: () {
                        if (_formKey.currentState!.validate() ||
                            firstName.text.isNotEmpty ||
                            lastName.text.isNotEmpty ||
                            email.text.isNotEmpty ||
                            phoneNumber.text.isNotEmpty ||
                            lastName.text.isNotEmpty ||
                            donationAmount.text.isNotEmpty) {
                          // Fluttertoast.showToast(
                          //     msg:
                          //         'Donation is under maintenance right now please try again later...');

                          // showDialog(
                          //     context: context,
                          //     builder: (context) => Dialog(
                          //           child: Container(
                          //             height: 100,
                          //             child: Center(
                          //               child: Column(
                          //                 mainAxisSize: MainAxisSize.min,
                          //                 children: [
                          //                   CircularProgressIndicator(
                          //                     color: Colors.purple,
                          //                   ),
                          //                   Text('Loading...')
                          //                 ],
                          //               ),
                          //             ),
                          //           ),
                          //         ));

                          callFunction(
                            firstName.text,
                            lastName.text,
                            email.text,
                            phoneNumber.text,
                            donationAmount.text,
                          );
                          setState(() {
                            _formKey.currentState!.reset();
                            firstName.clear();
                            lastName.clear();
                            phoneNumber.clear();
                            email.clear();
                            donationAmount.clear();
                            FocusScope.of(context).unfocus();
                          });
                        }
                      },
                      child: Text(
                        'DONATE NOW',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
