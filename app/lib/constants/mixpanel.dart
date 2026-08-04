import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class MixPanelHook with ChangeNotifier {
  Future<Mixpanel> initMixpanel() async {
    return await Mixpanel.init("486d0eca331af723fa069de6c32398b4",
        trackAutomaticEvents: true);
  }

  Future<void> trackEvent(Mixpanel mixPanel, String event) async {
    mixPanel.track(event, properties: {
      "TimeStamp": DateFormat('dd MMM, yyy, hh:mm a').format(DateTime.now())
    });
    print("TRACKED");
  }
}
