import 'package:flutter/material.dart';
import 'package:iskcon/widgets/AboutUsSection.dart';
import 'package:iskcon/widgets/customAppBar.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    return Scaffold(
    appBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: CustomAppBar(title: 'ABOUT US')),
      // appBar: AppBar(
      //   toolbarHeight: 46,
      //   title: Text(
      //     'About Us',
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
      //   // automaticallyImplyLeading: false,
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            margin: EdgeInsets.only(top: 20),
            width: double.infinity,
            child: Column(
              children: <Widget>[
                AboutUsSection(
                  screen: screen,
                  imgContent: 'Punjabi Bagh Iskcon Temple',
                  imgUrl:
                      'https://res.cloudinary.com/thrillophilia/image/upload/c_fill,f_auto,fl_progressive.strip_profile,g_auto,h_600,q_auto,w_auto/v1/filestore/k51qf70cbnm3btf5k568r3ttiroc_1569220440_Birla_Mandir.jpg.jpg',
                  para1:
                      'Nostalgia would best describe the emotion as we go back 14 years ago to Radhastami, 20th September 2007. The arrival of Krsna-Balaram was a watershed moment for ISKCON Punjabi Bagh as the 1984-established Radhika Raman Temple expanded to Sri Sri Radha Radhika Raman Krsna Balarama Mandir & Vedic Educational Centre to accommodate Sri Sri Krsna-Balarama. Garudadeva -Their carrier came along.',
                  para2:
                      '“They are the actual youth preachers of Punjabi Bagh” remarked an enthusiast. Indeed, youth preaching never remained the same after the arrival of Krsna Balarama. In fact NOTHING, remained the same. “Krsna is paling in comparison to Balarama” pointed out an innocent devotee as the deities were uncovered after the “Netra-Unmilana”(unveiling the deities for the first time).',
                ),
                AboutUsSection(
                  screen: screen,
                  imgUrl:
                      'https://www.bhaktibharat.com/photo/mandir/iskcon-temple-chowpatty/dp.jpg?tr=w-425',
                  para1:
                      'Krsna Balarama soon attained a cult-following of thousands of devotees enamored by Their beauty. “They are not just beautiful, They are very merciful too!”, observed a senior devotee.',
                  para2:
                      'Since the dramatic episode surrounding our ‘exodus’ from 14/63 Punjabi Bagh (west) during the summer of 2005 to this new venue, ISKCON Punjabi Bagh was known as a “small category” temple off the beaten track. Our new abode used to be a banquet hall, being converted into a temple. Preaching was gathering pace with a dedicated congregation building up around the temple steadily.',
                ),
                AboutUsSection(
                  screen: screen,
                  imgUrl:
                      'https://iskconstatic.s3.ap-south-1.amazonaws.com/iskconvrindavan/pages/About-Us-946316be49c890d.jpeg',
                  para1:
                      'Deity worship standards improved as new pujaris were sent to Mayapur for  systematic training. Soon Punjabi Bagh started making headlines around the ISKCON world for the stunning darsana of Their Lordships. Online (live) darsana started in February 2012 making Radha Radhika Raman & Krsna Balarama a household name around ISKCON. After a decade, we are a huge family of thousands of happy devotees part of the larger body of ISKCON as kindred spirits.',
                  para2:
                      ' In 2017, ISKCON Punjabi Bagh in its new avatara is in its 10th year. With festivals like Janmasthami drawing worshippers to the tune of 300,000 or month-long Kartik celebrations attracting visitors upwards of 200,000, ISKCON Punjabi Bagh’s greatest assets are its devotees. They are our real floral tribute to Srila Prabhupada.',
                  para3:
                      '” These temples, they are just like oasis in the desert for the conditioned souls to quench the thirst of their desire for real happiness. “',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
