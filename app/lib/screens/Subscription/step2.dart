import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iskcon/screens/Subscription/step3.dart';
import 'package:iskcon/widgets/customAppBar.dart';

class SubscriptionStep2 extends StatefulWidget {
  final String magazineName;
  const SubscriptionStep2({super.key, required this.magazineName});

  @override
  State<SubscriptionStep2> createState() => _SubscriptionStep2State();
}

class _SubscriptionStep2State extends State<SubscriptionStep2> {
  String selectedOption = '';
  var subscriptionName;
  var subscriptionId;
  List offerList = [
    '1 yr ( 12 issues) couriered @ Rs. 700 PLUS additional services.',
    '2 yr (24 issues) couriered @ Rs. 1,350, SAVE 5% PLUS additional services.',
    '5 yr (60 issues) couriered @ Rs. 3,250, SAVE 10% PLUS additional services.',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: CustomAppBar(title: 'Offers')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Step 1 of 2',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .merge(TextStyle(fontFamily: 'Lexend')),
            ),
            SizedBox(
              height: 10,
            ),
            FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('subscriptionTypes')
                    .get(),
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? Center(
                          child: Text('No Data Found'),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var data = snapshot.data!.docs[index];
                            print(data);
                            return RadioListTile(
                              activeColor: Colors.black,
                              value: snapshot.data!.docs[index]['amount']
                                  .toString(),
                              groupValue: selectedOption,
                              onChanged: (value) {
                                setState(() {
                                  selectedOption = value!;
                                  subscriptionName = data['name'];
                                  subscriptionId = data.id;
                                  print(subscriptionName);
                                  print(subscriptionId);
                                  print(selectedOption);
                                });
                              },
                              title: Text(
                                data['name'],
                                style: TextStyle(color: Colors.black
                                    // fontWeight:
                                    //     selectedOption == offerList[index]
                                    //         ? FontWeight.bold
                                    //         : null
                                    ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider();
                          },
                        );
                }),
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
                  onPressed: () {
                    if (selectedOption != '') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubscriptionStep3(
                                    docId: subscriptionId,
                                    name: subscriptionName,
                                    amount: selectedOption,
                                    magazineName: widget.magazineName,
                                  )));
                    } else {
                      Fluttertoast.showToast(
                          msg: 'Please Select the Option...');
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
    );
  }
}
