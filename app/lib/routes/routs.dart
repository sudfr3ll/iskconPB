// ignore_for_file: constant_identifier_names, unused_shown_name

import 'package:get/get.dart' show GetPage, Transition;
import 'package:iskcon/routes/routes_view.dart';
import 'package:iskcon/screens/splashScreen.dart';

class Routes {
  static const INITIAL = RoutesView.ROOT;
  static final routes = [
    GetPage(name: RoutesView.ROOT, page: () => SplashScreem())
  ];
}
