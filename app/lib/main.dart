// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:iskcon/constants/provider.dart';
import 'package:iskcon/routes/routes_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:iskcon/widgets/customBottomNav.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'screens/splashScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}


Future<void> initialization(BuildContext? context) async {
  await Future.delayed(
    const Duration(seconds: 2),
  );
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}



class _MyAppState extends State<MyApp> {

  final DeviceInfoPlugin deviceInfoPlugin =
      DeviceInfoPlugin();


  @override
  void initState() {
    super.initState();

    getToken();
    getDeciveInfo();
  }



  Future<void> getDeciveInfo() async {

    final AndroidDeviceInfo value =
        await deviceInfoPlugin.androidInfo;

    final SharedPreferences pref =
        await SharedPreferences.getInstance();


    String? uuid = pref.getString('id');


    if (uuid == null) {

      uuid = const Uuid().v1();

      await pref.setString(
        'id',
        uuid,
      );


      await FirebaseFirestore.instance
          .collection('Devices')
          .doc(uuid)
          .set(
        {
          'device': value.device,
          'brand': value.brand,
          'hardware': value.hardware,
          'manufacturer':
              value.manufacturer,
        },
        SetOptions(
          merge: true,
        ),
      );
    }


    await pref.setString(
        'device', value.device);

    await pref.setString(
        'brand', value.brand);

    await pref.setString(
        'hardware', value.hardware);

    await pref.setBool(
        'isPhysicalDevice',
        value.isPhysicalDevice);

    await pref.setString(
        'manufacturer',
        value.manufacturer);


    debugPrint('UUID is $uuid');
  }





  Future<void> getToken() async {

    final FirebaseMessaging firebaseMessaging =
        FirebaseMessaging.instance;


    final String? token =
        await firebaseMessaging.getToken();


    debugPrint('Token is : $token');


    if (token == null) return;


    final productId =
        await FirebaseFirestore.instance
            .collection('Tokens')
            .where(
              'token',
              isEqualTo: token,
            )
            .get();


    if (productId.docs.isEmpty) {

      await FirebaseFirestore.instance
          .collection('Tokens')
          .add({
        'token': token,
      });

    } else {

      debugPrint(
          'Token Already Available');
    }
  }






  @override
  Widget build(BuildContext context) {

    return MultiProvider(

      providers: [

        ChangeNotifierProvider(
          create: (_) => AppState(),
        ),

      ],

      child: MaterialApp(

        debugShowCheckedModeBanner: false,

        title: 'Iskcon',


        theme: ThemeData(

          appBarTheme:
              const AppBarTheme(

            backgroundColor:
                Color.fromRGBO(
                    239,126,30,1),

            elevation: 0,

          ),


          switchTheme:
              const SwitchThemeData(

            thumbColor:
                WidgetStatePropertyAll(
              Colors.white,
            ),

          ),

        ),


        initialRoute:
            RoutesView.ROOT,


        routes: {

          RoutesView.ROOT:
              (context) =>
                  SplashScreem(),


          RoutesView.HOME:
              (context) =>
                  CustomBottomNavBar(),

        },

      ),
    );
  }
}