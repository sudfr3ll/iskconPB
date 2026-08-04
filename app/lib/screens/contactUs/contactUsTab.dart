// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:iskcon/screens/contactUs/enquiryForm.dart';
import 'package:iskcon/screens/contactUs/reachUs.dart';
import 'package:iskcon/widgets/customAppBar.dart';

class ContactUsTab extends StatefulWidget {
  const ContactUsTab({super.key});

  @override
  State<ContactUsTab> createState() => _ContactUsTabState();
}

class _ContactUsTabState extends State<ContactUsTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: CustomAppBar(title: 'CONTACT US')),
        // appBar: AppBar(
        //   centerTitle: true,
        //   title: Text(
        //     'CONTACT US',
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
        //   toolbarHeight: 46,
        // ),
        body: Column(
          children: [
            TabBar(
              unselectedLabelColor: Colors.black54,
              labelColor: Color(0xff9C5AB1),
              // Color.fromRGBO(119, 97, 172, 1),
              indicatorColor: Color(0xff9C5AB1),
              //  Color.fromRGBO(119, 97, 172, 1),
              tabs: [
                Tab(
                  child: Text(
                    'ENQUIRY FORM',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Tab(
                  child: Text(
                    'REACH US',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: TabBarView(
                  children: [
                    EnquiryForm(),
                    ReachUs(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
