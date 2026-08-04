import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isAppNotificationsEnabled = false;
  bool isEmailNotificationsEnabled = false;
  bool isSMSNotificationsEnabled = false;
  bool isAppUpdateEnabled = false;
  bool isSoundEnabled = false;

  void handleSwitch(String name, bool value) {
    switch (name) {
      case 'appNotification':
        return setState(() {
          isAppNotificationsEnabled = value;
        });
      case 'emailNotification':
        return setState(() {
          isEmailNotificationsEnabled = value;
        });
      case 'smsNotification':
        return setState(() {
          isSMSNotificationsEnabled = value;
        });
      case 'appUpdate':
        return setState(() {
          isAppUpdateEnabled = value;
        });
      case 'sound':
        return setState(() {
          isSoundEnabled = value;
        });
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 46,
        title: Text(
          'Settings'.toUpperCase(),
          style: TextStyle(fontSize: 15),
        ), actions: [Image.asset('assets/images/logo2.png')],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            margin: EdgeInsets.only(top: 10),
            width: double.infinity,
            child: Column(
              children: <Widget>[
                Switches(
                  label: 'App Notification',
                  handleSwitch: handleSwitch,
                  value: isAppNotificationsEnabled,
                  switchValue: 'appNotification',
                ),
                SizedBox(height: 10),
                Switches(
                  label: 'Email Notification',
                  handleSwitch: handleSwitch,
                  value: isEmailNotificationsEnabled,
                  switchValue: 'emailNotification',
                ),
                SizedBox(height: 10),
                Switches(
                  label: 'SMS Notification',
                  handleSwitch: handleSwitch,
                  value: isSMSNotificationsEnabled,
                  switchValue: 'smsNotification',
                ),
                SizedBox(height: 10),
                Switches(
                  label: 'App Update',
                  handleSwitch: handleSwitch,
                  value: isAppUpdateEnabled,
                  switchValue: 'appUpdate',
                ),
                SizedBox(height: 10),
                Switches(
                  label: 'Sound',
                  handleSwitch: handleSwitch,
                  value: isSoundEnabled,
                  switchValue: 'sound',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Switches extends StatelessWidget {
  final Function handleSwitch;
  final bool value;
  final String label;
  final String switchValue;
  const Switches({
    super.key,
    required this.label,
    required this.handleSwitch,
    required this.value,
    required this.switchValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        Transform.scale(
          scale: 1.2,
          child: Switch.adaptive(
            activeTrackColor: Color.fromRGBO(242, 196, 6, 1),
            value: value,
            onChanged: (val) {
              handleSwitch(switchValue, val);
            },
          ),
        ),
      ],
    );
  }
}
