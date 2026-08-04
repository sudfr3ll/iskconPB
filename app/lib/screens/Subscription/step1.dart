import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:iskcon/screens/Subscription/step2.dart';
import 'package:iskcon/widgets/customAppBar.dart';

class SubscriptionStep1 extends StatefulWidget {
  final String title;
  const SubscriptionStep1({super.key, required this.title});

  @override
  State<SubscriptionStep1> createState() => _SubscriptionStep1State();
}

class _SubscriptionStep1State extends State<SubscriptionStep1> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: CustomAppBar(title: widget.title)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Color.fromRGBO(0, 67, 114, 1),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Back to Godhead Hindi Magazine',
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.headlineSmall!.merge(
                            TextStyle(color: Color.fromRGBO(248, 102, 0, 1))),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Text(
                        'Can bring corpse back to life',
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      Text(
                        'In this age of Kaliyuga, the only remedy from limitless and endless, pain, suffering, agony and fear is to take the shelter of the Supreme Lord, who is though situated in everyone’s heart, reveals Himself to us when we read or hear about Him. This BTG magazine is the best and easiest way to approach the Lord and take His shelter.',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      Text(
                        'Subscribe to the endless Love and peace that is awaiting us.',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      ImageSlideshow(
                        initialPage: 0,
                        indicatorColor: Color(0xff9C5AB1),
                        indicatorBackgroundColor: Colors.grey,
                        onPageChanged: (value) {
                          print('Page changed: $value');
                        },
                        autoPlayInterval: 3000,
                        isLoop: true,
                        children: [
                          Image.network(
                            'https://www.iskconpunjabibagh.com/wp-content/uploads/2020/03/2-1.png',
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                      // Image.network(
                      //   'https://www.iskconpunjabibagh.com/wp-content/uploads/2020/03/2-1.png',
                      // ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      SizedBox(
                        height: 40,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromRGBO(248, 102, 0, 1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SubscriptionStep2(
                                            magazineName:
                                                'Back to Godhead Hindi Magazine',
                                          )));
                            },
                            child: Text('Subscribe Now')),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                color: Color.fromRGBO(242, 237, 233, 1),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Back to Godhead English Magazine',
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.headlineSmall!.merge(
                              TextStyle(
                                color: Color.fromRGBO(248, 102, 0, 1),
                              ),
                            ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Text(
                        'Passport to the Spiritual World',
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      Text(
                        'Even at the last moment of your life, if you remember Lord Krishna… You can go back to Godhead. Back to Godhead Magazine- your daily appetite of remembrance of Krishna. Am i always prepared to go back to godhead? ',
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      Text(
                        'Subscribe to the key that open the door to Spiritual world.',
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      ImageSlideshow(
                        initialPage: 0,
                        indicatorColor: Color(0xff9C5AB1),
                        indicatorBackgroundColor: Colors.grey,
                        onPageChanged: (value) {
                          print('Page changed: $value');
                        },
                        autoPlayInterval: 3000,
                        isLoop: true,
                        children: [
                          Image.network(
                            'https://www.iskconpunjabibagh.com/wp-content/uploads/2020/03/4-1-1.png',
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      SizedBox(
                        height: 40,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromRGBO(248, 102, 0, 1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SubscriptionStep2(
                                            magazineName:
                                                'Back to Godhead English Magazine',
                                          )));
                            },
                            child: Text('Subscribe Now')),
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
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
