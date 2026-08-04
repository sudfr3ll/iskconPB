import 'package:iskcon/constants/mixpanel.dart';

class UseMixPanel {
  Future<bool> sendTracking({event}) async {
    var mixPanel = await MixPanelHook().initMixpanel();
    await MixPanelHook().trackEvent(mixPanel, event);
    return true;
  }
}
