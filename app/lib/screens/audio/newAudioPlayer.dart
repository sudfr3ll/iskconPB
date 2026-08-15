import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iskcon/screens/audio/audioplaylist.dart';
import 'package:iskcon/widgets/customAppBar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:isolate';
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class TrackTag {
  final String id;
  final String title;
  const TrackTag({required this.id, required this.title});
}

class MyAudioApp extends StatelessWidget {
  final String title;
  final int index;
  // final String chapter;
  final String audioLink;
  final String imageLink;
  final dynamic data;
  const MyAudioApp(
      {super.key,
      required this.title,
      // required this.chapter,
      required this.audioLink,
      required this.imageLink,
      this.data,
      required this.index,
      required id});

  @override
  Widget build(BuildContext context) {
    return MainScreen(
      audioLink: audioLink,
      // chapter: chapter,
      imageLink: imageLink,
      title: title,
      data: data,
      index: index,
    );
  }
}

class MainScreen extends StatefulWidget {
  final int index;
  final String title;
  // final String chapter;
  final String? audioLink;
  final String imageLink;
  final dynamic data;
  const MainScreen(
      {super.key,
      required this.title,
      // required this.chapter,
      this.audioLink,
      required this.imageLink,
      this.data,
      required this.index});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int nextMediaId = 0;
  late AudioPlayer _player;
  int timeProgress = 0;
  int audioDuration = 0;
  dynamic _playlist;
  var deviceid;
  int addedCount = 0;
  List playListNames = [];
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @pragma('vm:entry-point')
  static void downloadCallback(
    String id,
    int status,
    int progress,
  ) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');

    send?.send([id, status, progress]);
  }

  Future<void> getdata() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print(pref.getStringList('playlist'));
    setState(() {
      playListNames.addAll(pref.getStringList('playlist')!.map((e) => e));
    });
  }

  Future<void> getDeviceInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      deviceid = pref.getString('id');
    });
    pref.getString('device');
    pref.getString('brand');
    pref.getString('hardware');
    pref.getString('id');
    pref.getBool('isPhysicalDevice');
    pref.getString('manufacturer');
  }

  @override
  void initState() {
    super.initState();

    getDeviceInfo();
    _player = AudioPlayer();
    print('Plyer Status is : ${_player.playing}');

    AudioPlayer.clearAssetCache();
    print('${_player.playing}');
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    getdata();
    _init();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;

    print(widget.audioLink);

    _playlist = ConcatenatingAudioSource(
        children: List<AudioSource>.generate(widget.data.length, (index) {
      return AudioSource.uri(Uri.parse(widget.data[index]['url']),
          tag: TrackTag(
            id: '${widget.index}',
            title: widget.data[index]['title'],
          ));
    })
        //  [
        //   AudioSource.uri(Uri.parse(widget.audioLink),
        //       tag: MediaItem(
        //         id: '${_nextMediaId++}',
        //         album: widget.chapter,
        //         title: widget.title,
        //         artUri: Uri.parse(
        //             "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg"),
        //       )),
        //   AudioSource.uri(
        //     Uri.parse(
        //         "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3"),
        //     tag: MediaItem(
        //       id: '${_nextMediaId++}',
        //       album: "Science Friday",
        //       title: "A Salute To Head-Scratching Science",
        //       artUri: Uri.parse(
        //           "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg"),
        //     ),
        //   ),
        //   AudioSource.uri(
        //     Uri.parse(
        //         "https://s3.amazonaws.com/scifri-segments/scifri201711241.mp3"),
        //     tag: MediaItem(
        //       id: '${_nextMediaId++}',
        //       album: "Science Friday",
        //       title: "From Cat Rheology To Operatic Incompetence",
        //       artUri: Uri.parse(
        //           "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg"),
        //     ),
        //   ),
        //   AudioSource.uri(
        //     Uri.parse("asset:///audio/nature.mp3"),
        //     tag: MediaItem(
        //       id: '${_nextMediaId++}',
        //       album: "Public Domain",
        //       title: "Nature Sounds",
        //       artUri: Uri.parse(
        //           "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg"),
        //     ),
        //   ),
        // ]

        );

    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onDone: () {},
        cancelOnError: true, onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    try {
      await _player.setAudioSource(_playlist,
          initialIndex: widget.index, preload: false);
    } catch (e, stackTrace) {
      // Catch load errors: 404, invalid url ...
      print("Error loading playlist: $e");
      print(stackTrace);
    }
    _player.playing != true ? _player.play() : null;
  }

  @override
  void dispose() {
    super.dispose();
    _player.dispose();
  }

  // Widget _offsetPopup() => PopupMenuButton<int>(
  //     itemBuilder: (context) => [
  //           PopupMenuItem(
  //             onTap: () {
  //               //         showDialog(
  //               // context: context,
  //               // builder: (context) {
  //               //   return Dialog(
  //               //     child: Container(
  //               //       height: 100,
  //               //       width: 100,
  //               //       child: Center(child: CircularProgressIndicator()),
  //               //     ),
  //               //   );
  //               // });
  //               // shareImage();
  //             },
  //             value: 1,
  //             child: Wrap(
  //               children: [
  //                 Icon(Icons.share),
  //                 SizedBox(
  //                   width: 10,
  //                 ),
  //                 Text(
  //                   "Share",
  //                   style: TextStyle(
  //                       color: Colors.black, fontWeight: FontWeight.w700),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           PopupMenuItem(
  //             // onTap: () => Image_Downloader(),
  //             value: 2,
  //             child: Wrap(
  //               children: [
  //                 Icon(Icons.download),
  //                 SizedBox(
  //                   width: 10,
  //                 ),
  //                 Text(
  //                   "Download",
  //                   style: TextStyle(
  //                       color: Colors.black, fontWeight: FontWeight.w700),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //     icon: Container(
  //         height: double.infinity,
  //         width: double.infinity,
  //         alignment: Alignment.center,
  //         decoration:
  //             ShapeDecoration(color: Colors.purple, shape: StadiumBorder()),
  //         child: Icon(
  //           Icons.more_vert,
  //           color: Colors.white,
  //         )));

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: CustomAppBar(title: 'Player')),
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   centerTitle: true,
      //   title: Text('Player'),
      //   leading: IconButton(
      //       onPressed: () {
      //         Navigator.pop(context, true);
      //       },
      //       icon: Icon(Icons.arrow_back)),
      //   actions: [
      //     Image.asset(
      //       'assets/images/logo.png',
      //       height: 40,
      //       width: 40,
      //     ),
      //     SizedBox(
      //       width: 10,
      //     )
      //   ],
      // ),
      body: Container(
        color: Color.fromRGBO(119, 97, 172, 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: StreamBuilder<SequenceState?>(
                stream: _player.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  if (state?.sequence.isEmpty ?? true) {
                    return const SizedBox();
                  }
                  final metadata = state!.currentSource!.tag as TrackTag;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Image.asset(
                            widget.imageLink,
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          )),
                        ),
                      ),
                      // Text(metadata.album!,
                      //     style: Theme.of(context)
                      //         .textTheme
                      //         .titleLarge
                      //         .merge(TextStyle(color: Colors.white))),
                      SizedBox(
                        height: 20,
                        child: Center(
                          child: Marquee(
                            text: metadata.title,
                            style: TextStyle(color: Colors.white),
                            blankSpace: 40,
                            scrollAxis: Axis.horizontal,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            ControlButtons(_player),
            StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return !snapshot.hasData
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ProgressBar(
                            thumbColor: Colors.purple.shade300,
                            progressBarColor: Colors.purple,
                            baseBarColor: Colors.purple.shade400,
                            progress: positionData!.position,
                            buffered: positionData.bufferedPosition,
                            total: positionData.duration,
                            onSeek: ((value) {
                              _player.seek(value);
                            })),
                      );
                // SeekBar(
                //   duration: positionData?.duration ?? Duration.zero,
                //   position: positionData?.position ?? Duration.zero,
                //   bufferedPosition:
                //       positionData?.bufferedPosition ?? Duration.zero,
                //   onChangeEnd: (newPosition) {
                //     _player.seek(newPosition);
                //   },
                // );
              },
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                StreamBuilder<LoopMode>(
                  stream: _player.loopModeStream,
                  builder: (context, snapshot) {
                    final loopMode = snapshot.data ?? LoopMode.off;
                    const icons = [
                      Icon(Icons.repeat, color: Colors.grey),
                      Icon(Icons.repeat, color: Colors.white),
                      Icon(Icons.repeat_one, color: Colors.white),
                    ];
                    const cycleModes = [
                      LoopMode.off,
                      LoopMode.all,
                      LoopMode.one,
                    ];
                    final index = cycleModes.indexOf(loopMode);
                    return IconButton(
                      icon: icons[index],
                      onPressed: () {
                        _player.setLoopMode(cycleModes[
                            (cycleModes.indexOf(loopMode) + 1) %
                                cycleModes.length]);
                      },
                    );
                  },
                ),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => AudioPlayList()));
                      // final DeviceInfoPlugin deviceInfoPlugin =
                      //     DeviceInfoPlugin();
                      // deviceInfoPlugin.androidInfo.then((value) {
                      //   return showModalBottomSheet(
                      //       enableDrag: true,
                      //       context: context,
                      //       builder: (context) {
                      //         return Container(
                      //           height: size.height * .8,
                      //           child: Column(
                      //             children: [
                      //               Icon(Icons.drag_handle),
                      //               SizedBox(
                      //                 height: 10,
                      //               ),
                      //               StreamBuilder(
                      //                   stream: FirebaseFirestore.instance
                      //                       .collection('Devices')
                      //                       .doc(value.id)
                      //                       .collection('playlists')
                      //                       .snapshots(),
                      //                   builder: (context, snapshot) {
                      //                     return !snapshot.hasData
                      //                         ? Center(
                      //                             child:
                      //                                 CircularProgressIndicator(
                      //                               color: Colors.purple,
                      //                             ),
                      //                           )
                      //                         : snapshot.data!.docs.length == 0
                      //                             ? Center(
                      //                                 child: Text(
                      //                                     'No play list available'),
                      //                               )
                      //                             : ListView.builder(
                      //                               shrinkWrap: true,
                      //                                 itemCount: snapshot
                      //                                     .data!.docs.length,
                      //                                 itemBuilder:
                      //                                     (BuildContext context,
                      //                                         int index1) {
                      //                                   var listdata = snapshot
                      //                                       .data!.docs[index1];
                      //                                   return ListTile(
                      //                                     leading: Text(
                      //                                         '${index1 + 1}'),
                      //                                     title: Text(
                      //                                         '${listdata['name']}'),
                      //                                   );
                      //                                 });
                      //                   }),
                      //             ],
                      //           ),
                      //         );
                      //       });
                      // });
                    },
                    icon: Icon(
                      Icons.library_music,
                      color: Colors.grey,
                    )),
                Expanded(
                  child: Text(
                    "Playlist",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .merge(TextStyle(color: Colors.white)),
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      TextEditingController textEditingController =
                          TextEditingController();
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Create local playlist'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  'Create local playlist with 0 song(S) from now playing queue'),
                              TextFormField(
                                cursorColor: Color.fromRGBO(119, 97, 172, 1),
                                decoration: InputDecoration(
                                    focusColor: Color.fromRGBO(119, 97, 172, 1),
                                    label: Text('Playlist Name')),
                                controller: textEditingController,
                              )
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel',
                                  style: TextStyle(
                                      color: Color.fromRGBO(119, 97, 172, 1))),
                            ),
                            TextButton(
                              onPressed: () async {
                                final DeviceInfoPlugin deviceInfoPlugin =
                                    DeviceInfoPlugin();

                                print(deviceInfoPlugin.deviceInfo);

                                if (textEditingController.text.isNotEmpty) {
                                  deviceInfoPlugin.androidInfo.then((value) {
                                    print(value.device);
                                    print(value.brand);
                                    print(value.hardware);
                                    print(value.id);
                                    print(value.isPhysicalDevice);
                                    print(value.manufacturer);
                                    FirebaseFirestore.instance
                                        .collection('Devices')
                                        .doc(deviceid)
                                        .collection('playlists')
                                        .add(
                                      {
                                        'createdAt':
                                            FieldValue.serverTimestamp(),
                                        'name': textEditingController.text,
                                        'audios': []
                                      },
                                    ).then((value1) => FirebaseFirestore
                                                .instance
                                                .collection('Devices')
                                                .doc(value.id)
                                                .set({
                                              'device': value.device,
                                              'brand': value.brand,
                                              'hardware': value.hardware,
                                              'manufacturer': value.manufacturer
                                            }, SetOptions(merge: true)));
                                  });

                                  Navigator.pop(context);
                                  Fluttertoast.showToast(
                                      msg: 'Playlist Created');
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'Please enter playlist name');
                                }
                              },
                              child: Text('Create',
                                  style: TextStyle(
                                      color: Color.fromRGBO(119, 97, 172, 1))),
                            )
                          ],
                        ),
                      );
                    },
                    icon: Icon(Icons.playlist_add, color: Colors.grey)),
                StreamBuilder<bool>(
                  stream: _player.shuffleModeEnabledStream,
                  builder: (context, snapshot) {
                    final shuffleModeEnabled = snapshot.data ?? false;
                    return IconButton(
                      icon: shuffleModeEnabled
                          ? const Icon(Icons.shuffle, color: Colors.white)
                          : const Icon(Icons.shuffle, color: Colors.grey),
                      onPressed: () async {
                        final enable = !shuffleModeEnabled;
                        if (enable) {
                          await _player.shuffle();
                        }
                        await _player.setShuffleModeEnabled(enable);
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              height: 240.0,
              child: StreamBuilder<SequenceState?>(
                stream: _player.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  final sequence = state?.sequence ?? [];
                  return ReorderableListView(
                    shrinkWrap: true,
                    onReorder: (int oldIndex, int newIndex) {
                      if (oldIndex < newIndex) newIndex--;
                      _playlist.move(oldIndex, newIndex);
                    },
                    children: [
                      for (var i = 0; i < sequence.length; i++)
                        Dismissible(
                          key: ValueKey(sequence[i]),
                          background: Container(
                            color: Colors.redAccent,
                            alignment: Alignment.centerRight,
                            child: const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                          onDismissed: (dismissDirection) {
                            _playlist.removeAt(i);
                          },
                          child: Material(
                            color: i == state!.currentIndex
                                ? Colors.purple.shade400
                                : Color.fromRGBO(112, 5, 195, 1),
                            child: ListTile(
                              // tileColor: Color.fromRGBO(112, 5, 195, 1),
                              leading: Icon(
                                Icons.drag_handle,
                                color: Colors.white,
                              ),
                              title: Text(
                                sequence[i].tag.title as String,
                                style: TextStyle(color: Colors.white),
                              ),
                              trailing: PopupMenuButton<int>(
                                  itemBuilder: (context) => [
                                        PopupMenuItem(
                                          onTap: () {
                                            // final DeviceInfoPlugin
                                            //     deviceInfoPlugin =
                                            //     DeviceInfoPlugin();
                                            // var deviceId;
                                            // AndroidDeviceInfo androidDeviceInfo;
                                            // deviceInfoPlugin.androidInfo
                                            //     .then((value) {
                                            //   setState(() {
                                            //     deviceId = value.id;
                                            //   });
                                            // });
                                            showBottomSheet(
                                                enableDrag: true,
                                                context: context,
                                                builder: (context) => SizedBox(
                                                      height: size.height * .8,
                                                      child: Column(
                                                        children: [
                                                          Icon(Icons
                                                              .drag_handle),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                              sequence[i].tag.title as String),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          StreamBuilder(
                                                              stream: FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'Devices')
                                                                  .doc(deviceid)
                                                                  .collection(
                                                                      'playlists')
                                                                  .snapshots(),
                                                              builder: (context,
                                                                  snapshot) {
                                                                return !snapshot
                                                                        .hasData
                                                                    ? Expanded(
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child:
                                                                              CircularProgressIndicator(
                                                                            color:
                                                                                Colors.purple,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : snapshot
                                                                            .data!
                                                                            .docs
                                                                            .isNotEmpty
                                                                        ? ListView.builder(
                                                                            shrinkWrap: true,
                                                                            // physics: NeverScrollableScrollPhysics(),
                                                                            itemCount: snapshot.data!.docs.length,
                                                                            itemBuilder: (context, index2) {
                                                                              var datas = snapshot.data!.docs[index2];
                                                                              return InkWell(
                                                                                onTap: () {
                                                                                  FirebaseFirestore.instance.collection('Devices').doc(deviceid).collection('playlists').doc(datas.id).set({
                                                                                    'audios': FieldValue.arrayUnion([
                                                                                      {
                                                                                        'title': sequence[i].tag.title as String,
                                                                                        'url': widget.data[i]['url'],
                                                                                      }
                                                                                    ])
                                                                                  }, SetOptions(merge: true)).whenComplete(() {
                                                                                    Fluttertoast.showToast(msg: 'Add to ${datas['name']}');
                                                                                    Navigator.pop(context);
                                                                                  });
                                                                                },
                                                                                child: Padding(
                                                                                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                                                                  child: ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                    child: Container(
                                                                                      height: 70,
                                                                                      color: Colors.white,
                                                                                      child: Row(
                                                                                        children: <Widget>[
                                                                                          Container(
                                                                                            color: Color.fromRGBO(119, 97, 172, 1),
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
                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: <Widget>[
                                                                                                Text(
                                                                                                  datas['name'],
                                                                                                  style: Theme.of(context).textTheme.titleMedium,
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                          Icon(Icons.arrow_forward_ios, color: Colors.black54),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              );

                                                                              // ListTile(
                                                                              //   onTap: () {
                                                                              //     FirebaseFirestore.instance.collection('Devices').doc(deviceId).collection('playlists').doc(datas.id).set({
                                                                              //       'audios': FieldValue.arrayUnion([
                                                                              //         {
                                                                              //           'title': sequence[i].tag.title as String,
                                                                              //           'url': widget.data[i]['url'],
                                                                              //         }
                                                                              //       ])
                                                                              //     }, SetOptions(merge: true)).whenComplete(() => Fluttertoast.showToast(msg: 'Add to ${datas['name']}'));
                                                                              //   },
                                                                              //   leading: Text('${index2 + 1}'),
                                                                              //   title: Text(datas['name']),
                                                                              // );
                                                                            })
                                                                        : Expanded(
                                                                            child:
                                                                                Align(alignment: Alignment.center, child: Text('Please create playlist')),
                                                                          );
                                                              }),
                                                        ],
                                                      ),
                                                    ));
                                            // final DeviceInfoPlugin
                                            //     deviceInfoPlugin =
                                            //     DeviceInfoPlugin();
                                            // deviceInfoPlugin.androidInfo.then(
                                            //     (value) =>
                                            //         FirebaseFirestore
                                            //             .instance
                                            //             .collection('Devices')
                                            //             .doc(value.id)
                                            //             .collection('playlists')
                                            //             .doc(
                                            //                 'CKEdE6uuPq1x7d2Gi39Q')
                                            //             .set(
                                            //                 {
                                            //               'name': '',
                                            //               'audio': []
                                            //             },
                                            //                 SetOptions(
                                            //                     merge: true)));
                                          },
                                          value: 1,
                                          child: Wrap(
                                            children: [
                                              Icon(Icons.playlist_add),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Add to playlist",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          onTap: () async {
                                            final status = await Permission
                                                .storage
                                                .request();

                                            if (status.isGranted) {
                                              Directory directory = Directory(
                                                  '/storage/emulated/0/Download');
                                              // final externalDir =
                                              //     await getExternalStorageDirectories(
                                              //         type: StorageDirectory.downloads);
                                              Fluttertoast.showToast(
                                                  msg: 'Downloading...');
                                              FlutterDownloader.enqueue(
                                                  fileName:
                                                      '${widget.data[i]['title']}.mp3',
                                                  url: widget.data[i]['url'],
                                                  savedDir: directory.path,
                                                  showNotification:
                                                      true, // show download progress in status bar (for Android)
                                                  openFileFromNotification:
                                                      true, // click on notification to open downloaded file (for Android)
                                                  headers: {});
                                            } else {
                                              print('Permission Denied');
                                            }
                                          },
                                          value: 2,
                                          child: Wrap(
                                            children: [
                                              Icon(Icons.download),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Download",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                  icon: Container(
                                      height: double.infinity,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      decoration: ShapeDecoration(
                                          color: Colors.purple,
                                          shape: StadiumBorder()),
                                      child: Icon(
                                        Icons.more_vert,
                                        color: Colors.white,
                                      ))),
                              // Wrap(
                              //   children: [
                              //     IconButton(
                              //       onPressed: () async {
                              //         final status =
                              //             await Permission.storage.request();

                              //         if (status.isGranted) {
                              //           Directory directory = Directory(
                              //               '/storage/emulated/0/Download');
                              //           // final externalDir =
                              //           //     await getExternalStorageDirectories(
                              //           //         type: StorageDirectory.downloads);
                              //           Fluttertoast.showToast(
                              //               msg: 'Downloading...');
                              //           FlutterDownloader.enqueue(
                              //               fileName:
                              //                   '${widget.data[i]['title']}.mp3',
                              //               url: widget.data[i]['url'],
                              //               savedDir: directory.path,
                              //               showNotification:
                              //                   true, // show download progress in status bar (for Android)
                              //               openFileFromNotification:
                              //                   true, // click on notification to open downloaded file (for Android)
                              //               headers: {});
                              //         } else {
                              //           print('Permission Denied');
                              //         }
                              //       },
                              //       icon: Icon(Icons.download),
                              //       color: Colors.white,
                              //     ),
                              //   ],
                              // ),

                              onTap: () {
                                _player.seek(Duration.zero, index: i);
                              },
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.add),
      //   onPressed: () {
      //     _playlist.add(AudioSource.uri(
      //       Uri.parse("asset:///audio/nature.mp3"),
      //       tag: MediaItem(
      //         id: '${_nextMediaId++}',
      //         album: "Public Domain",
      //         title: "Nature Sounds ${++_addedCount}",
      //         artUri: Uri.parse(
      //             "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg"),
      //       ),
      //     ));
      //   },
      // ),
    );
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // IconButton(
        //   icon: const Icon(
        //     Icons.volume_up,
        //     color: Colors.white,
        //   ),
        //   onPressed: () {
        //     // showSliderDialog(
        //     //   context: context,
        //     //   title: "Adjust volume",
        //     //   divisions: 10,
        //     //   min: 0.0,
        //     //   max: 1.0,
        //     //   stream: player.volumeStream,
        //     //   onChanged: player.setVolume,
        //     // );
        //   },
        // ),
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: const Icon(
              Icons.skip_previous,
              color: Colors.white,
            ),
            onPressed: player.hasPrevious ? player.seekToPrevious : null,
          ),
        ),
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: const CircularProgressIndicator(
                  color: Colors.purple,
                ),
              );
            } else if (playing != true) {
              return IconButton(
                icon: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                ),
                iconSize: 64.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(
                  Icons.pause,
                  color: Colors.white,
                ),
                iconSize: 64.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: const Icon(
                  Icons.replay,
                  color: Colors.white,
                ),
                iconSize: 64.0,
                onPressed: () => player.seek(Duration.zero,
                    index: player.effectiveIndices.first),
              );
            }
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: const Icon(
              Icons.skip_next,
              color: Colors.white,
            ),
            onPressed: player.hasNext ? player.seekToNext : null,
          ),
        ),
        // StreamBuilder<double>(
        //   stream: player.speedStream,
        //   builder: (context, snapshot) => IconButton(
        //     icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
        //         style: const TextStyle(
        //           fontWeight: FontWeight.bold,
        //           color: Colors.white,
        //         )),
        //     onPressed: () {
        //       // showSliderDialog(
        //       //   context: context,
        //       //   title: "Adjust speed",
        //       //   divisions: 10,
        //       //   min: 0.5,
        //       //   max: 1.5,
        //       //   stream: player.speedStream,
        //       //   onChanged: player.setSpeed,
        //       // );
        //     },
        //   ),
        // ),
      ],
    );
  }
}

class PositionData {
  PositionData(this.position, this.bufferedPosition, this.duration);
  Duration position;
  Duration bufferedPosition;
  Duration duration;
}
