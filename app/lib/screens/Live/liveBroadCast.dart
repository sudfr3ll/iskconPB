// ignore_for_file: no_leading_underscores_for_local_identifiers, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:iskcon/widgets/customAppBar.dart';

class LiveBroadCast extends StatefulWidget {
  final String type;
  const LiveBroadCast({super.key, required this.type});

  @override
  State<LiveBroadCast> createState() => _LiveBroadCastState();
}

class _LiveBroadCastState extends State<LiveBroadCast> {
  double _currentSliderValue = 20;
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: CustomAppBar(title: 'LIVE BROADCAST')),
      // AppBar(
      //   automaticallyImplyLeading: widget.type == 'true' ? true : false,
      //   centerTitle: true,
      //   title: Text('LIVE BROADCAST'),
      // ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    color: Colors.green,
                    height: _size.height * 0.3,
                    child: Image.network(
                      'https://www.iskcon.org/img/2014/12/radha-shyam-300x200.jpg',
                      width: _size.width,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Positioned(
                    top: _size.height * 0.2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.play_circle_outline_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                          Container(
                            width: _size.width * 0.75,
                            child: Slider(
                              inactiveColor: Colors.grey,
                              activeColor: Colors.white,
                              value: _currentSliderValue,
                              min: 0,
                              max: 100,
                              divisions: 100,
                              label: _currentSliderValue.round().toString(),
                              onChanged: (double value) {
                                setState(() {
                                  _currentSliderValue = value;
                                });
                              },
                            ),
                          ),
                          Icon(
                            Icons.screen_rotation,
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Text(
                      '\u2022',
                      style: TextStyle(fontSize: 40, color: Colors.green),
                    ),
                    Text(
                      'LIVE',
                      style: TextStyle(),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(5)),
                      width: 60,
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.center,
                        children: [
                          Icon(
                            Icons.visibility,
                            size: 15,
                          ),
                          Text('1.5k')
                        ],
                      ),
                    ),
                    Spacer(),
                    Text(
                      '15th Nov, 2022',
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Live Darshan from ISKCON TEMPLE at punjabi Bagh',
                      style: Theme.of(context).textTheme.titleLarge!,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Connect with us through live broadcasting of temple hall',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Timings:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '8am - 9am',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '10am - 1pm',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '6pm - pam',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'You can also tune in our channel on Youtube',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 120,
                      child: TextButton.icon(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.amber,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          onPressed: () {},
                          icon: Icon(
                            Icons.account_balance_wallet,
                            color: Colors.white,
                          ),
                          label: Text(
                            'DONATE',
                            style: TextStyle(color: Colors.white),
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
