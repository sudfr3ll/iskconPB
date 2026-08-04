// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iskcon/screens/audio/newAudioPlayer.dart';
import 'package:iskcon/widgets/customAppBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioPlayList extends StatefulWidget {
  const AudioPlayList({super.key});

  @override
  State<AudioPlayList> createState() => _AudioPlayListState();
}

class _AudioPlayListState extends State<AudioPlayList> {
  var deviceid;
  var device;
  var brand;
  var hardware;
  bool? isPhysicalDevice;
  var manufacturer;

  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  Future<void> getDeviceInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      deviceid = pref.getString('id');
      device = pref.getString('device');
      hardware = pref.getString('hardware');
      brand = pref.getString('brand');
      isPhysicalDevice = pref.getBool('isPhysicalDevice');
      manufacturer = pref.getString('manufacturer');
    });

    pref.getString('id');
  }

  @override
  void initState() {
    getDeviceInfo();
    super.initState();
  }

  void createPlayList() {
    TextEditingController textEditingController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create local playlist'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Create local playlist with 0 song(S) from now playing queue'),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              cursorColor: Color.fromRGBO(119, 97, 172, 1),
              decoration: InputDecoration(
                  labelStyle: TextStyle(color: Color.fromRGBO(119, 97, 172, 1)),
                  label: Text('Playlist  Name')),
              controller: textEditingController,
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Color(0xff9C5AB1),

                // color: Color.fromRGBO(119, 97, 172, 1),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

              print(deviceInfoPlugin.deviceInfo);
              if (textEditingController.text.isNotEmpty) {
                FirebaseFirestore.instance
                    .collection('Devices')
                    .doc(deviceid)
                    .collection('playlists')
                    .add(
                  {
                    'createdAt': FieldValue.serverTimestamp(),
                    'name': textEditingController.text,
                    'audios': []
                  },
                ).then((value1) => FirebaseFirestore.instance
                            .collection('Devices')
                            .doc(deviceid)
                            .set({
                          'device': device,
                          'brand': brand,
                          'hardware': hardware,
                          'manufacturer': manufacturer
                        }, SetOptions(merge: true)));

                Navigator.pop(context);
                Fluttertoast.showToast(msg: 'Playlist Created');
              } else {
                Fluttertoast.showToast(msg: 'Please enter playlist name');
              }
            },
            child: Text('Create',
                style: TextStyle(
                  color: Color(0xff9C5AB1),

                  // color: Color.fromRGBO(119, 97, 172, 1)
                )),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: CustomAppBar(title: 'Playlists')),
      // appBar: AppBar(
      //   title: Text('Playlists'),
      //   centerTitle: true,
      // ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Devices')
                .doc(deviceid)
                .collection('playlists')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.purple,
                      ),
                    )
                  : snapshot.data!.docs.isEmpty
                      ? Center(
                          child: Text('No play list available'),
                        )
                      : ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index1) {
                            var listdata = snapshot.data!.docs[index1];
                            return InkWell(
                                onTap: () {
                                  listdata['audios'].length == 0
                                      ? Fluttertoast.showToast(
                                          msg: 'No Songs Available')
                                      : Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) => MyAudioApp(
                                                    title: listdata['name'],
                                                    id: listdata.id,
                                                    audioLink: '',
                                                    index: index1,
                                                    imageLink:
                                                        'assets/images/musicimage.jpg',
                                                    data: listdata['audios'],
                                                  )));
                                },
                                child: Dismissible(
                                  background: Container(
                                    color: Colors.redAccent,
                                    alignment: Alignment.centerRight,
                                    child: const Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Icon(Icons.delete,
                                          color: Colors.white),
                                    ),
                                  ),
                                  onDismissed: (dismissDirection) {
                                    FirebaseFirestore.instance
                                        .collection('Devices')
                                        .doc(deviceid)
                                        .collection('playlists')
                                        .doc(listdata.id)
                                        .delete()
                                        .whenComplete(() => Fluttertoast.showToast(
                                            msg:
                                                '${listdata['name']} deleted successfully'));
                                  },
                                  key: ValueKey(index1),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        height: 70,
                                        color: Colors.white,
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              color: Color.fromRGBO(
                                                  119, 97, 172, 1),
                                              width: 70,
                                              height: 70,
                                              child: Center(
                                                child: Image.asset(
                                                  'assets/features/music.png',
                                                  height: 27,
                                                ),
                                              ),
                                            ),
                                            // Container(
                                            //   color: Colors.amber.shade500,
                                            //   width: 70,
                                            //   height: 70,
                                            //   child: Icon(Icons.music_note,
                                            //       color: Colors.white),
                                            // ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    listdata['name'],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Icon(Icons.arrow_forward_ios,
                                                color: Colors.black54),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ));
                            // ListTile(
                            //   leading: Text('${index1 + 1}'),
                            //   title: Text('${listdata['name']}'),
                            // );
                          });
            }),
      ),
      floatingActionButton: InkWell(
        onTap: createPlayList,
        child: Container(
          height: 50,
          width: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(colors: [
                Color(0xff9C5AB1),
                Color(0xff9C5AB1),
              ])),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: Colors.white,
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                'Create',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          // child: FloatingActionButton.extended(
          //   onPressed: createPlayList,
          //   label: Wrap(
          //     crossAxisAlignment: WrapCrossAlignment.center,
          //     children: [
          //       Icon(Icons.add),
          //       SizedBox(
          //         width: 4,
          //       ),
          //       Text('Create'),
          //     ],
          //   ),
          // ),
        ),
      ),
    );
  }
}
