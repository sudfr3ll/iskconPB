import 'package:url_launcher/url_launcher.dart';

class UrlLaunchers {
  // Uri parsedUri = Uri.parse(url);

  Future<void> urlLaunch(url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
