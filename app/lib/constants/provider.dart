import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iskcon/constants/apiConstant.dart';
import 'package:iskcon/models/cityModel.dart';
import 'package:iskcon/models/stateModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  String? coverImage;
  String? darshanPic;
  String? ytpublishTime;
  String ytUrl = '';
  String? youtubeId;
  String? ytTitle;
  String? ytDescription;
  String? apiKye;
  String? host;
  int? port;
  bool active = false;
  bool donationStatus = false;
  bool showDarshan = false;
  bool change = false;
  bool waiting = false;
  String? merchantId;
  bool waiting1 = false;
  bool imageLoading = false;
  List<States>? stateList;
  List<Cities>? citiesList;
  var youtubedata;
  var decodedData;
  void changebool() {
    change = !change;
    notifyListeners();
  }

  void showDarshanPic() {
    showDarshan = !showDarshan;
    notifyListeners();
  }

  Future<void> loadState() async {
    waiting = false;
    stateList = await ApiConstant().getStates();
    waiting = true;
    notifyListeners();
  }

  Future<void> loadCities(String statecode) async {
    waiting1 = false;
    citiesList = await ApiConstant().getCities(statecode);
    waiting1 = true;
    notifyListeners();
  }

  void changeDonationStatus() {
    donationStatus = true;
    notifyListeners();
  }

  Future<void> getLiveDetails() async {
    imageLoading = false;
    // await ApiConstant().youtubeLiveApi().then((value) {
    //   coverImage = value['snippet']['thumbnails']['high']['url'];
    //   ytUrl = value['id']['videoId'];
    //   ytTitle = value['snippet']['title'];
    //   ytDescription = value['snippet']['description'];
    //   ytpublishTime = value['snippet']['publishedAt'];
    //   active = true;
    //   print(coverImage);
    //   print(ytUrl);
    // }).whenComplete(() => imageLoading = true);
    // youtubedata = await ApiConstant().youtubeLiveApi();
    // decodedData = jsonDecode(youtubedata.body);
    // print(decodedData);
    // print('Status Code is : ${youtubedata.statusCode}');
    // if (youtubedata.statusCode == 200) {
    //   print('Getting Data Api.....');
    //   print(decodedData);
    //   coverImage =
    //       decodedData['items'][0]['snippet']['thumbnails']['high']['url'];
    //   youtubeId = decodedData['items'][0]['id']['videoId'];
    //   active = true;
    //   imageLoading = true;
    //   notifyListeners();
    // } else {

    print('Getting Data Firestore.....');
    await FirebaseFirestore.instance
        .collection('Live')
        .doc('Darshan')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      coverImage = documentSnapshot.get('coverImage');
      darshanPic = documentSnapshot.get('darshanPic');
      active = documentSnapshot.get('active');
      ytDescription = documentSnapshot.get('description');
    }).whenComplete(() => imageLoading = true);
    notifyListeners();
    // }
    // notifyListeners();
  }

  Future<void> getPaymentData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await FirebaseFirestore.instance
        .collection('Integrations')
        .doc('PayU')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      prefs.setString(
          'merchId', documentSnapshot.get('credentials.merchantId'));
    });

    notifyListeners();
  }

  Future<void> getTypsenseCredentials() async {
    FirebaseFirestore.instance
        .collection('Integrations')
        .doc('Typesense')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      print(documentSnapshot.get('creds.host'));
      print(documentSnapshot.get('creds.apiKey'));
      print(documentSnapshot.get('creds.port'));
      host = documentSnapshot.get('creds.host');
      apiKye = documentSnapshot.get('creds.apiKey');
      port = documentSnapshot.get('creds.port');
    });
    notifyListeners();
  }

  Future<void> callFunction() async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('youtube-getLiveVideoId');

      final results = await callable.call();
      if (results.data['status'] == false) {
        Fluttertoast.showToast(
            msg: 'We are facing some issue! Please try again later.');
      } else {
        print(results.data);
        coverImage = results.data['coverImage'];
        ytUrl = results.data['videoId'];
        // ignore: use_build_context_synchronously
      }

      print(results.data);
    } on FirebaseFunctionsException catch (error) {
      print(error.message);
    }
    notifyListeners();
  }
}
