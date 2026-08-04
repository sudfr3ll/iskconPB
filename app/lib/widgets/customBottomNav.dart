// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iskcon/constants/provider.dart';
import 'package:iskcon/constants/useMixPanel.dart';
import 'package:iskcon/screens/Donate/DonateScreen.dart';
import 'package:iskcon/screens/Home/HomeScreen.dart';
import 'package:iskcon/screens/Live/videoPlayer.dart';
import 'package:iskcon/screens/Message/MessageScreen.dart';
import 'package:iskcon/widgets/modalBottonSheet.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:pandabar/pandabar.dart';
import 'package:provider/provider.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  // New: icon states: show menu vs. show close.
  bool isShowingMenu = false;
  bool circleButtonToggle = false;
  bool change = false;
  String page = 'Home';

  @override
  void initState() {
    _checkVersion();
    // Future.delayed((Duration(seconds: 5)));
    // _checkVersion();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    super.initState();
  }

  Future<void> _checkVersion() async {
    print('Check Version.....');

    final newVersion =
    NewVersionPlus(
        androidId: "com.iskcon.punjabibagh",
        iOSId: "com.iskcon.pb",
    );
    final newstatus = await newVersion.getVersionStatus();
    final status = newstatus;
    print('App Version : ${status!.localVersion}');
    print('PlayStore Version : ${status.storeVersion}');
    if (status.canUpdate == true) {
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogText:
            "Please update the app from ${status.localVersion} to ${status.storeVersion}",
        allowDismissal: false,
        dismissAction: () {
          SystemNavigator.pop();
        },
        dismissButtonText: 'Exit',
      );
    }
    print('Version check successfully...');
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> sendTracking({title}) async {
    await UseMixPanel()
        .sendTracking(event: "Clicked on $title from bottom navigation bar");
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppState>(context);
    return Scaffold(
        extendBody: true,
        body: Builder(
          builder: (context) {
            switch (page) {
              case 'Home':
                return HomeScreen();
              case 'Live Darshan':
                return VideoPlayer(
                  youtubeId: '',
                );
              case 'Donate':
                return DonateScreen(
                    // title: liveTitle!,
                    // id: docid,
                    // image: coverImage,
                    );
              case 'Message':
                return MessageScreen();
              default:
                return Container();
            }
          },
        ),
        bottomNavigationBar: Builder(builder: (context) {
          return PandaBar(
              backgroundColor: Color(0xff9C5AB1),
              //  Color.fromRGBO(119, 21, 190, 1),
              buttonColor: Colors.white,
              //  Color.fromRGBO(215, 205, 240, 1),
              buttonSelectedColor: Colors.white,
              fabColors: [Color(0xff9C5AB1), Color(0xff9C5AB1)],
              fabIcon: AnimatedIcon(
                  color: Colors.white,
                  icon: AnimatedIcons.menu_close,
                  progress: _animationController),
              onFabButtonPressed: () {
                // isShowingMenu = !isShowingMenu;
                // if (isShowingMenu) {
                //   _animationController.forward();
                // } else {
                //   _animationController.reverse();
                // }
                if (provider.change == true) {
                  provider.changebool();
                  _animationController.reverse();
                  Navigator.pop(context);
                } else {
                  provider.changebool();
                  _animationController.forward();

                  showBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) => ModalBottmSheet(
                            animationController: _animationController,
                          ));
                }

                // print(provider.change);
              },
              buttonData: [
                PandaBarButtonData(
                  id: 'Home',
                  icon: Icons.home,
                  title: 'Home',
                ),
                PandaBarButtonData(
                    id: 'Live Darshan',
                    icon: Icons.video_call,
                    title: 'Live Darshan'),
                PandaBarButtonData(
                    id: 'Donate',
                    icon: Icons.volunteer_activism,
                    title: 'Donate'),
                PandaBarButtonData(
                    id: 'Message', icon: Icons.mail, title: 'Message'),
              ],
              onChange: (id) async {
                await sendTracking(title: id.toString());

                setState(() {
                  page = id;
                });
              });
        }));
  }
}
