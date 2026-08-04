// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:iskcon/routes/routes_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutBottomSheet extends StatefulWidget {
  const LogoutBottomSheet({super.key});

  @override
  State<LogoutBottomSheet> createState() => _LogoutBottomSheetState();
}

class _LogoutBottomSheetState extends State<LogoutBottomSheet> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.3,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30))),
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.1,
          ),
          Text(
            'Do you want to logout?',
            style: Theme.of(context).textTheme.titleLarge!,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'You can login with same mobile number later',
            style: Theme.of(context).textTheme.bodySmall!,
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: size.width * 0.4,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black26),
                            borderRadius: BorderRadius.circular(20))),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancle',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(
                  width: size.width * 0.4,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      setState(() {
                        prefs.clear();
                      });
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          RoutesView.LOGIN, (Route<dynamic> route) => false);
                    },
                    child: Text('Logout'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
