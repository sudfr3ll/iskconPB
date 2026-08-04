import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iskcon/constants/useMixPanel.dart';
import 'package:iskcon/screens/Quotes/QuotesWidget.dart';
import 'package:iskcon/widgets/customAppBar.dart';
import 'package:shimmer/shimmer.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  List<Map<String, dynamic>> demoMessage = [
    {
      'date': '28th October, 2022',
      'para':
          'Prabhupad used to often talk about “Vrindavan vision,” i.e, looking at the good qualities of everyone. By looking at the good qualities of everyone, one can appreciate the effort that every vaisnava is making, and by encouraging every vaisnava to engage in devotional service, unlimited strenght can be obtained. Prabhupada used to give the example that that blades of grass are strong rope and nobody can cut that rope.',
    },
  ];

  final carousel.CarouselSliderController controller =
    carousel.CarouselSliderController();
    
  int activeIndex = 0;

  void carouselPrev() => controller.previousPage();

  void carouselNext() => controller.nextPage();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Future<void> sendTracking({title}) async {
      await UseMixPanel().sendTracking(
          event: "Clicked on $title in Events (Category level 1) in Home");
    }

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: CustomAppBar(title: 'QUOTES')),
      //  AppBar(
      //   toolbarHeight: 46,
      //   title: Text(
      //     'QUOTES',
      //     style: TextStyle(fontSize: 15),
      //   ),
      //   actions: [
      //     Image.asset(
      //       'assets/images/logo.png',
      //       height: 40,
      //       width: 40,
      //     ),
      //     SizedBox(
      //       width: 10,
      //     )
      //   ],
      //   centerTitle: true,
      // ),
      body: SingleChildScrollView(
          child: Container(
        height: MediaQuery.of(context).size.height * 0.89,
        decoration: BoxDecoration(
          color: Color(0xff9C5AB1),
          //  Color.fromRGBO(119, 97, 172, 1),
          image: DecorationImage(
            image: AssetImage('assets/features1/quoteoftheday.png'),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('Quotes')
                .orderBy('createdAt', descending: true)
                .get(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Colors.purple,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text('Loading...')
                          ],
                        ),
                      ),
                    )
                  : carousel.CarouselSlider.builder(
                      carouselController: controller,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: ((context, index, realIndex) {
                        var data = snapshot.data!.docs[index];
                        var date = DateFormat('dd MMMM yyyy');
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              !snapshot.hasData ||
                                      snapshot.data!.docs.isEmpty
                                  ? Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        margin: EdgeInsets.only(top: 15),
                                        child: Text(
                                          '20th October, 2022',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ))
                                  : Container(
                                      margin: EdgeInsets.only(top: 15),
                                      child: Text(
                                        (() {
                                          final dataMap = data.data();
                                          final createdAt =
                                              dataMap['createdAt'];
                                          final dateField = dataMap['date'];

                                          if (dateField != null &&
                                              dateField is Timestamp) {
                                            return date
                                                .format(dateField.toDate());
                                          } else if (createdAt != null &&
                                              createdAt is Timestamp) {
                                            return date
                                                .format(createdAt.toDate());
                                          } else {
                                            return date.format(DateTime.now());
                                          }
                                        })(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Container(
                                  width: 85,
                                  height: 36,
                                  // alignment: Alignment.bottomLeft,
                                  // padding: EdgeInsets.only(left: 15),
                                  margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.04,
                                  ),
                                  // padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor:
                                          Color.fromRGBO(17, 112, 114, 1),
                                      foregroundColor: Colors.white,
                                      // padding:
                                      //     EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(10),
                                          topLeft: Radius.circular(10),
                                        ),
                                      ),
                                    ),
                                    onPressed: carouselPrev,
                                    child: Wrap(
                                      children: [
                                        Icon(
                                          Icons.arrow_back_ios,
                                          size: 16,
                                        ),
                                        Text(
                                          'PREV',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                              QuotesWidget(
                                  date: data['createdAt'].toString(),
                                  para: data['quote'],
                                  data: data),
                              SizedBox(height: 5),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: SizedBox(
                                  width: 85,
                                  height: 36,
                                  // alignment: Alignment.bottomRight,
                                  // padding: EdgeInsets.only(right: 15),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor:
                                          Color.fromRGBO(17, 112, 114, 1),
                                      foregroundColor: Colors.white,
                                      // padding:
                                      //     EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(10),
                                          topLeft: Radius.circular(10),
                                        ),
                                      ),
                                    ),
                                    onPressed: carouselNext,
                                    child: Wrap(
                                      children: [
                                        Text(
                                          'NEXT',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      options: carousel.CarouselOptions(
                        enableInfiniteScroll: false,
                        initialPage: 0,
                        height: size.height * 0.8,
                        autoPlay: false,
                        enlargeCenterPage: true,
                        viewportFraction: 0.9,
                      ),
                    );
            }),
      )),
    );
  }
}
