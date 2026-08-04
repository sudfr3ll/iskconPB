import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class DataBaseSerice {
  final _firebase = FirebaseFirestore.instance;
  FirebaseFunctions functions = FirebaseFunctions.instance;
  Future checkUser(uid) async {
    return _firebase.collection('users').doc(uid).get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> liveStream() {
    return _firebase.collection('Live').doc('Darshan').get();
  }

  Future messageList() {
    return _firebase
        .collection('Message')
        .orderBy('createdAt', descending: true)
        .get();
  }

  // Future qutoesList() {
  //   return _firebase
  //       .collection('Quotes')
  //       .orderBy('createdAt', descending: true)
  //       .get();
  // }

  Future socialMedial() {
    return _firebase.collection('Settings').doc('socialMedia').get();
  }

  Future reachUs() {
    return _firebase.collection('Settings').doc('contactUs').get();
  }

  Future categoryL1(type) {
    return _firebase
        .collection('Categories-L1')
        .where('type', isEqualTo: type)
        .where('active', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .get();
  }

  Future categoryL2(id, type) {
    print('Id is : $id');
    return _firebase
        .collection('Categories-L2')
        .where('categoryId_L1', isEqualTo: id)
        .where('type', isEqualTo: type)
        .where('active', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .get();
  }

  Future categoryL3(id1, id2, type) {
    return _firebase
        .collection('Categories-L3')
        .where('categoryId_L1', isEqualTo: id1)
        .where('categoryId_L2', isEqualTo: id2)
        .where('active', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .where('type', isEqualTo: type)
        .get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCategoryList(String collection, String id) {
    return _firebase
        .collection(collection)
        .where('categories', arrayContains: id)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future enquiryForm(Map<String, dynamic> model) {
    return _firebase.collection('Enquiries').add(model);
  }

  Future eventsList() {
    return _firebase
        .collection('Events')
        .orderBy('createdAt', descending: true)
        .get();
  }

  Future festivalList() {
    return _firebase.collection('Festivals').orderBy('date').get();
  }

  Future newsList() {
    return _firebase
        .collection('News')
        .orderBy('createdAt', descending: true)
        .get();
  }

  Future donationList() {
    return _firebase
        .collection('DonationTypes')
        .orderBy('createdAt', descending: true)
        .get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getYoutubekey() {
    return _firebase.collection('Settings').doc('youTube').get();
  }

  Future blogsList() {
    return _firebase
        .collection('Blogs')
        .orderBy('createdAt', descending: true)
        .get();
  }

  Future getPaymentData() {
    return _firebase.collection('Integrations').doc('PayU').get();
  }

  Future getPages() async {
    List typeData = [];
    return await _firebase
        .collection('Pages')
        .doc('Homepage')
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      for (int i = 0; i < documentSnapshot.get('sections').length; i++) {
        typeData.add(documentSnapshot.get('sections')[i]);
      }
      print('Sections are : $typeData');
      return typeData;
    });
  }

  Future homesections(type) async {
    return await _firebase
        .collection('Pages')
        .doc('Homepage')
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      List sections = documentSnapshot.get('sections');
      for (int i = 0; i < sections.length; i++) {
        // type == sections[i]['type'] ? print(true) : print(false);
        if (type == sections[i]['type']) {
          return await _firebase
              .collection('Widgets')
              .doc(sections[i]['widgetId'])
              .get()
              .then((DocumentSnapshot documentSnapshot1) async {
            // print('Widget Data is:  ${documentSnapshot1.data()}');
            List typeData = [];
            for (int i = 0; i < documentSnapshot1.get('list').length; i++) {
              DocumentSnapshot documentSnapshot3 = await _firebase
                  .collection(type)
                  .doc(documentSnapshot1.get('list')[i])
                  .get();
              var docRef = await _firebase
                  .collection(type)
                  .doc(documentSnapshot3.id)
                  .get();
              if (docRef.exists) {
                typeData.add(documentSnapshot3.data());
              }
            }
            return typeData;
          });
        }
      }
    });
  }

  Future getHomePages(type) async {
    dynamic pageData;
    pageData = await _firebase
        .collection('Pages')
        .doc('Homepage')
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      // print('Length : ${documentSnapshot.get('sections').length}');
      dynamic snapData = documentSnapshot.data();
      List sections = snapData['sections'];
      print(sections);
      var temp = sections.map((element) async {
        if ('News' == element['type']) {
          return await _firebase
              .collection('Widgets')
              .doc(element['widgetId'])
              .get()
              .then((DocumentSnapshot documentSnapshot1) async {
            dynamic response = documentSnapshot1.data();
            List loopDAta = response['list'];
            return loopDAta.map((element) async {
              await _firebase
                  .collection('News')
                  .doc(element)
                  .get()
                  .then((value) {
                return value.data();
              });
            });
            // for (var i = 0; i < response['list'].length; i++) {
            //   // print('  1111 1 ${response['list'][i]}');
            //   await _firebase
            //       .collection(type)
            //       .doc(documentSnapshot1.get('list')[i])
            //       .get()
            //       .then((value) => arr.add(value.data()));
            // }
            // for (var i = 0; i < documentSnapshot1.get('list').length; i++) {
            //   dynamic listdata = await _firebase
            //       .collection(type)
            //       .doc(documentSnapshot1.get('list')[i])
            //       .get();
            //   print(listdata['content']);

            // }
            // print('arr $arr');
            // List.generate(documentSnapshot1.get('list').length, (index) async {
            //   listdata = await _firebase
            //       .collection(type)
            //       .doc(documentSnapshot1.get('list')[index])
            //       .get();
            //   print(listdata['content']);
            //   return listdata;
            // });
          });
        } else {
          return {"NAME": "AYUASGHCHISA"};
        }
      });
      // arr = temp;

      print('ascas $temp');
      // for (int i = 0; i <= snapData['sections'].length; i++) {
      //   if (type == documentSnapshot.get('sections')[i]['type']) {
      //     await _firebase
      //         .collection('Widgets')
      //         .doc(documentSnapshot.get('sections')[i]['widgetId'])
      //         .get()
      //         .then((DocumentSnapshot documentSnapshot1) async {
      //       dynamic response = documentSnapshot1.data();
      //       for (var i = 0; i < response['list'].length; i++) {
      //         // print('  1111 1 ${response['list'][i]}');
      //         await _firebase
      //             .collection(type)
      //             .doc(documentSnapshot1.get('list')[i])
      //             .get()
      //             .then((value) => arr.add(value.data()));
      //       }

      //       // for (var i = 0; i < documentSnapshot1.get('list').length; i++) {
      //       //   dynamic listdata = await _firebase
      //       //       .collection(type)
      //       //       .doc(documentSnapshot1.get('list')[i])
      //       //       .get();
      //       //   print(listdata['content']);

      //       // }
      //       // print('arr $arr');
      //       // List.generate(documentSnapshot1.get('list').length, (index) async {
      //       //   listdata = await _firebase
      //       //       .collection(type)
      //       //       .doc(documentSnapshot1.get('list')[index])
      //       //       .get();
      //       //   print(listdata['content']);
      //       //   return listdata;
      //       // });
      //     });
      //   }
      // }
      // List.generate(documentSnapshot.get('sections').length, (index) {
      //   print(documentSnapshot.get('sections')[index]['type']);
      // });
    });

    return pageData;
  }

  Future getDailyDarshan() {
    print('Hello ');
    return _firebase
        .collection('Settings')
        .doc('daily-darshan')
        .get()
        .then((value) {
      var docId = value.get('categoryId');
      print('Doc Id is : $docId');
      return _firebase
          .collection('Categories-L1')
          .doc(docId)
          .get()
          .then((valu1) {
        print(valu1.data());
        return categoryL2(valu1.id, 'pictures');
      });
    });
  }

  Future getSettings(setting) {
    return _firebase.collection('Settings').doc(setting).get();
  }
}
