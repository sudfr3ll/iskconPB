import 'package:introduction_screen/introduction_screen.dart';
import 'package:iskcon/screens/Onboardingscreen/onBoardScreen.dart';

class OnboardingModel {
  List<PageViewModel> pages = [
    PageViewModel(
      title: "",
      bodyWidget: OnBoardScreen(),
      // image: _buildImage('img1.jpg'),
      // decoration: pageDecoration,
    ),
  ];

  List<PageViewModel> get pagedata {
    return pages;
  }
}
