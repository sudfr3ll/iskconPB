import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iskcon/screens/Login/loginScreen.dart';

class OnBoardScreen extends StatelessWidget {
  const OnBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  "https://w0.peakpx.com/wallpaper/687/933/HD-wallpaper-iskcon-bengaluru-iskon-karnataka-temple-thumbnail.jpg"),
              fit: BoxFit.cover),
        ),
        child: Container(
          color: Color.fromRGBO(119, 21, 190, 0.6),
          alignment: Alignment.bottomLeft,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 5)),
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.amber.withValues(alpha: .9),
                      shape: BoxShape.rectangle),
                  child: TextButton(
                      style: TextButton.styleFrom(
                          side: BorderSide(color: Colors.white, width: 3)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => LoginPage()));
                        // Navigator.of(context).pushNamed(LoginScreen.pathName);
                      },
                      child: Text(
                        'GET STARTED',
                        style: TextStyle(color: Colors.white),
                      )),
                )
                // Container(
                //     height: 100,
                //     decoration: BoxDecoration(
                //         color: Colors.amber, shape: BoxShape.circle),
                //     child: Image.asset('assets/images/logo.png')),

                // Center(
                //   child: Container(
                //     decoration: BoxDecoration(
                //         color: Colors.white, shape: BoxShape.circle),
                //     child: Image.network(
                //       'https://w7.pngwing.com/pngs/563/136/png-transparent-international-society-for-krishna-consciousness-iskcon-temple-chennai-bhagavad-gita-gaudiya-vaishnavism-maha-day-leaf-text-logo-thumbnail.png',
                //     ),
                //   ),
                // )
              ]),
        ),
      ),
    );
  }
}
