import 'package:audio_session/audio_session.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iskcon/constants/databaseService.dart';
import 'package:iskcon/screens/audio/newAudioPlayer.dart';
import 'package:iskcon/widgets/customAppBar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rxdart/rxdart.dart';

class AudioBookReading extends StatefulWidget {
  final String title;
  final String id;
  const AudioBookReading({super.key, required this.title, required this.id});

  @override
  State<AudioBookReading> createState() => _AudioBookReadingState();
}

class _AudioBookReadingState extends State<AudioBookReading> {
  bool show = false;
  var deviceid;
  var device;
  var brand;
  var hardware;
  bool? isPhysicalDevice;
  var manufacturer;
  late AudioPlayer _player;
  dynamic _playlist;
  Future<void> _init(int index1, dynamic data) async {
    final session = await AudioSession.instance;
    _playlist = ConcatenatingAudioSource(
      children: List<AudioSource>.generate(data.length, (index) {
        return AudioSource.uri(
          Uri.parse(data[index]['url']),
          tag: MediaItem(
            id: '$index1',
            // album: widget.data[index]['chapter'],
            title: data[index]['title'],
            // artUri: Uri.parse(widget.data[index]['coverImage']),
          ),
        );
      }),
    );

    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen(
      (event) {},
      onDone: () {},
      cancelOnError: true,
      onError: (Object e, StackTrace stackTrace) {
        print('A stream error occurred: $e');
      },
    );
    try {
      await _player.setAudioSource(
        _playlist,
        initialIndex: index1,
        preload: false,
      );
    } catch (e, stackTrace) {
      // Catch load errors: 404, invalid url ...
      print("Error loading playlist: $e");
      print(stackTrace);
    }
    _player.playing != true ? _player.play() : null;
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
    getDeviceInfo();
    _player = AudioPlayer();
    print('Player Status is : ${_player.playing}');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    show = false;
    _player.dispose();
  }

  List shows = [];
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _player.positionStream,
        _player.bufferedPositionStream,
        _player.durationStream,
        (position, bufferedPosition, duration) =>
            PositionData(position, bufferedPosition, duration ?? Duration.zero),
      );
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(title: widget.title),
      ),
      // appBar: AppBar(
      //   toolbarHeight: 46,
      //   centerTitle: true,
      //   title: Text(
      //     widget.title.toUpperCase(),
      //     style: TextStyle(fontSize: 15),
      //   ),
      // ),
      body: StreamBuilder(
        stream: DataBaseSerice().getCategoryList('Audios', widget.id),
        builder: (context, AsyncSnapshot snapshot) {
          return !snapshot.hasData
              ? ListView.builder(
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: ListTile(tileColor: Colors.white),
                        //  Container(
                        //   height: 200,
                        //   decoration: BoxDecoration(
                        //     color: Colors.white,
                        //     borderRadius: BorderRadius.only(
                        //         topRight: Radius.circular(30),
                        //         bottomLeft: Radius.circular(30)),
                        //   ),
                        // ),
                      ),
                    );
                  },
                )
              : Container(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data.docs[index];
                      return InkWell(
                        // onTap: () async {
                        // Navigator.push(
                        //     context,
                        //     CupertinoPageRoute(
                        //         builder: (context) => MyAudioApp(
                        //               index: index,
                        //               title: data['title'],
                        //               audioLink: data['url'],
                        //               id: data.id,
                        //               // imageLink: data.data()[
                        //               //             'resizedCoverImage'] ==
                        //               //         ''
                        //               //     ? data.data()[
                        //               //             'resizedCoverImage']
                        //               //         ['thumb']
                        //               //     : data.data()['coverImage'],
                        //               // chapter: data['chapter'],
                        //               data: snapshot.data.docs,
                        //               imageLink:
                        //                   'assets/images/musicimage.jpg',
                        //             )));
                        // },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: Colors.purple.shade50,
                            child: Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    setState(() {
                                      shows.clear();
                                      _player.dispose();
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MyAudioApp(
                                          index: index,
                                          title: data['title'],
                                          audioLink: data['url'],
                                          id: data.id,
                                          data: snapshot.data.docs,
                                          imageLink:
                                              'assets/images/musicimage.jpg',
                                        ),
                                      ),
                                    );
                                  },
                                  tileColor: Colors.purple.shade50,
                                  title: Text(
                                    data['title'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: Wrap(
                                    children: [
                                      !shows.contains(index)
                                          ? SizedBox()
                                          : StreamBuilder<PlayerState>(
                                              stream: _player.playerStateStream,
                                              builder: (context, snapshot) {
                                                final playerState =
                                                    snapshot.data;
                                                final processingState =
                                                    playerState
                                                        ?.processingState;
                                                final playing =
                                                    playerState?.playing;
                                                if (processingState ==
                                                        ProcessingState
                                                            .loading ||
                                                    processingState ==
                                                        ProcessingState
                                                            .buffering) {
                                                  return Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                    child:
                                                        const CircularProgressIndicator(
                                                          color: Colors.purple,
                                                        ),
                                                  );
                                                } else if (playing != true) {
                                                  return IconButton(
                                                    icon: const Icon(
                                                      Icons.play_circle_fill,
                                                      color: Colors.black,
                                                    ),
                                                    onPressed: _player.play,
                                                  );
                                                } else if (processingState !=
                                                    ProcessingState.completed) {
                                                  return IconButton(
                                                    icon: const Icon(
                                                      Icons.pause_circle_filled,
                                                      color: Colors.black,
                                                    ),
                                                    onPressed: _player.pause,
                                                  );
                                                } else {
                                                  return IconButton(
                                                    icon: const Icon(
                                                      Icons.replay,
                                                      color: Colors.black,
                                                    ),
                                                    onPressed: () =>
                                                        _player.seek(
                                                          Duration.zero,
                                                          index: _player
                                                              .effectiveIndices
                                                              .first,
                                                        ),
                                                  );
                                                }
                                              },
                                            ),
                                      shows.contains(index)
                                          ? SizedBox()
                                          : IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  show = true;
                                                  shows.clear();
                                                  shows.add(index);

                                                  _init(
                                                    index,
                                                    snapshot.data.docs,
                                                  );
                                                });
                                              },
                                              icon: Icon(
                                                Icons.play_circle_fill,
                                              ),
                                            ),

                                      PopupMenuButton(
                                        onSelected: (value) {
                                          if (value == 0) {
                                            createPlayList();
                                          } else if (value == 1) {
                                            showModalBottomSheet(
                                              enableDrag: true,
                                              context: context,
                                              builder: (context) => SizedBox(
                                                height: size.height * .8,
                                                child: Column(
                                                  children: [
                                                    Icon(Icons.drag_handle),
                                                    SizedBox(height: 10),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            12.0,
                                                          ),
                                                      child: Text(
                                                        '${data['title']}',
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    StreamBuilder(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection('Devices')
                                                          .doc(deviceid)
                                                          .collection(
                                                            'playlists',
                                                          )
                                                          .snapshots(),
                                                      builder: (context, snapshot) {
                                                        return !snapshot.hasData
                                                            ? Expanded(
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: CircularProgressIndicator(
                                                                    color: Colors
                                                                        .purple,
                                                                  ),
                                                                ),
                                                              )
                                                            : snapshot
                                                                  .data!
                                                                  .docs
                                                                  .isNotEmpty
                                                            ? ListView.builder(
                                                                shrinkWrap:
                                                                    true,
                                                                itemCount:
                                                                    snapshot
                                                                        .data!
                                                                        .docs
                                                                        .length,
                                                                itemBuilder: (context, index2) {
                                                                  var datas =
                                                                      snapshot
                                                                          .data!
                                                                          .docs[index2];
                                                                  return InkWell(
                                                                    onTap: () {
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                            'Devices',
                                                                          )
                                                                          .doc(
                                                                            deviceid,
                                                                          )
                                                                          .collection(
                                                                            'playlists',
                                                                          )
                                                                          .doc(
                                                                            datas.id,
                                                                          )
                                                                          .set(
                                                                            {
                                                                              'audios': FieldValue.arrayUnion(
                                                                                [
                                                                                  {
                                                                                    'title': data['title'],
                                                                                    'url': data['url'],
                                                                                  },
                                                                                ],
                                                                              ),
                                                                            },
                                                                            SetOptions(
                                                                              merge: true,
                                                                            ),
                                                                          )
                                                                          .whenComplete(() {
                                                                            Fluttertoast.showToast(
                                                                              msg: 'Add to ${datas['name']}',
                                                                            );
                                                                            Navigator.pop(
                                                                              context,
                                                                            );
                                                                          });
                                                                    },
                                                                    child: Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            8.0,
                                                                        horizontal:
                                                                            8.0,
                                                                      ),
                                                                      child: ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              10,
                                                                            ),
                                                                        child: Container(
                                                                          height:
                                                                              70,
                                                                          color:
                                                                              Colors.white,
                                                                          child: Row(
                                                                            children:
                                                                                <
                                                                                  Widget
                                                                                >[
                                                                                  Container(
                                                                                    color: Color.fromRGBO(
                                                                                      119,
                                                                                      97,
                                                                                      172,
                                                                                      1,
                                                                                    ),
                                                                                    width: 70,
                                                                                    height: 70,
                                                                                    child: Center(
                                                                                      child: Image.asset(
                                                                                        'assets/features/music.png',
                                                                                        height: 27,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 10,
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children:
                                                                                          <
                                                                                            Widget
                                                                                          >[
                                                                                            Text(
                                                                                              datas['name'],
                                                                                              style: Theme.of(
                                                                                                context,
                                                                                              ).textTheme.titleMedium,
                                                                                            ),
                                                                                          ],
                                                                                    ),
                                                                                  ),
                                                                                  Icon(
                                                                                    Icons.arrow_forward_ios,
                                                                                    color: Colors.black54,
                                                                                  ),
                                                                                ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              )
                                                            : Expanded(
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                    'Please create playlist',
                                                                  ),
                                                                ),
                                                              );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          } else if (value == 2) {
                                            SharePlus.instance.share(
                                              ShareParams(text: data['url']),
                                            );
                                          }
                                        },
                                        itemBuilder: (context) {
                                          return [
                                            PopupMenuItem(
                                              value: 0,
                                              child: Wrap(
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                children: [
                                                  Icon(Icons.playlist_add),
                                                  SizedBox(width: 4),
                                                  Text('Create Playlist'),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 1,
                                              child: Wrap(
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                children: [
                                                  Icon(Icons.add),
                                                  SizedBox(width: 4),
                                                  Text('Add to playlist'),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 2,
                                              child: Wrap(
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                children: [
                                                  Icon(Icons.share),
                                                  SizedBox(width: 4),
                                                  Text('Share'),
                                                ],
                                              ),
                                            ),
                                          ];
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                shows.contains(index)
                                    ? !_player.playing
                                          ? SizedBox()
                                          : Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Container(
                                                // decoration: BoxDecoration(
                                                //     color: Colors
                                                //         .purple.shade100,
                                                //     borderRadius:
                                                //         BorderRadius.circular(
                                                //             15)),
                                                // height: 150,
                                                // width: size.width,
                                                child: Center(
                                                  child: Column(
                                                    children: [
                                                      // SizedBox(
                                                      //   height: 10,
                                                      // ),
                                                      // StreamBuilder<
                                                      //     SequenceState?>(
                                                      //   stream: _player
                                                      //       .sequenceStateStream,
                                                      //   builder: (context,
                                                      //       snapshot) {
                                                      //     final state =
                                                      //         snapshot.data;
                                                      //     if (state?.sequence
                                                      //             .isEmpty ??
                                                      //         true) {
                                                      //       return const SizedBox();
                                                      //     }
                                                      //     final metadata = state!
                                                      //         .currentSource!
                                                      //         .tag as MediaItem;
                                                      //     return SizedBox(
                                                      //       height: 20,
                                                      //       child: Marquee(
                                                      //         scrollAxis: Axis
                                                      //             .horizontal,
                                                      //         text: metadata
                                                      //             .title,
                                                      //       ),
                                                      //     );
                                                      //   },
                                                      // ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
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
                                                          // StreamBuilder<
                                                          //     SequenceState?>(
                                                          //   stream: _player
                                                          //       .sequenceStateStream,
                                                          //   builder: (context,
                                                          //           snapshot) =>
                                                          //       IconButton(
                                                          //     icon:
                                                          //         const Icon(
                                                          //       Icons
                                                          //           .skip_previous,
                                                          //       color: Colors
                                                          //           .black,
                                                          //     ),
                                                          //     onPressed:
                                                          //         () async {
                                                          //       _player.hasPrevious
                                                          //           ? _player
                                                          //               .seekToPrevious
                                                          //           : await null;
                                                          //     },
                                                          //   ),
                                                          // ),

                                                          // StreamBuilder<
                                                          //     SequenceState?>(
                                                          //   stream: _player
                                                          //       .sequenceStateStream,
                                                          //   builder: (context,
                                                          //           snapshot) =>
                                                          //       IconButton(
                                                          //     icon:
                                                          //         const Icon(
                                                          //       Icons
                                                          //           .skip_next,
                                                          //       color: Colors
                                                          //           .black,
                                                          //     ),
                                                          //     onPressed: _player
                                                          //             .hasNext
                                                          //         ? _player
                                                          //             .seekToNext
                                                          //         : null,
                                                          //   ),
                                                          // ),

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
                                                      ),
                                                      StreamBuilder<
                                                        PositionData
                                                      >(
                                                        stream:
                                                            _positionDataStream,
                                                        builder: (context, snapshot) {
                                                          final positionData =
                                                              snapshot.data;
                                                          return !snapshot
                                                                  .hasData
                                                              ? Container()
                                                              : Padding(
                                                                  padding:
                                                                      const EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            16.0,
                                                                      ),
                                                                  child: ProgressBar(
                                                                    thumbColor: Colors
                                                                        .purple
                                                                        .shade300,
                                                                    progressBarColor:
                                                                        Colors
                                                                            .purple,
                                                                    baseBarColor: Colors
                                                                        .purple
                                                                        .shade400,
                                                                    progress:
                                                                        positionData!
                                                                            .position,
                                                                    buffered:
                                                                        positionData
                                                                            .bufferedPosition,
                                                                    total: positionData
                                                                        .duration,
                                                                    onSeek: ((value) {
                                                                      _player
                                                                          .seek(
                                                                            value,
                                                                          );
                                                                    }),
                                                                  ),
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
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                          //  Stack(
                          //   children: [
                          //     Container(
                          //       decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.only(
                          //               topRight: Radius.circular(30),
                          //               bottomLeft: Radius.circular(30)),
                          //           image: DecorationImage(
                          //               fit: BoxFit.cover,
                          //               image: AssetImage(
                          //                   'assets/images/musicimage.jpg'))),
                          //       height: 200,
                          //     ),
                          //     Container(
                          //       height: 200,
                          //       decoration: BoxDecoration(
                          //         color: Colors.black.withOpacity(0.4),
                          //         borderRadius: BorderRadius.only(
                          //             topRight: Radius.circular(30),
                          //             bottomLeft: Radius.circular(30)),
                          //       ),
                          //     ),
                          //     Column(
                          //       mainAxisAlignment:
                          //           MainAxisAlignment.spaceEvenly,
                          //       children: [
                          //         InkWell(
                          //           onTap: () {
                          //           },
                          //           child: Padding(
                          //             padding: const EdgeInsets.all(16.0),
                          //             child: Align(
                          //                 alignment: Alignment.topRight,
                          //                 child: Container(
                          //                   height: 40,
                          //                   width: 40,
                          //                   decoration: BoxDecoration(
                          //                       color: Color.fromRGBO(
                          //                           38, 195, 119, 1),
                          //                       shape: BoxShape.circle),
                          //                   child: Icon(
                          //                     Icons.share,
                          //                     color: Colors.white,
                          //                   ),
                          //                 )),
                          //           ),
                          //         ),
                          //         Center(
                          //             child: SvgPicture.asset(
                          //           'assets/svg/031-play-button.svg',
                          //           height: 50,
                          //           color: Colors.white,
                          //         )
                          //             //  Icon(
                          //             //   Icons.play_circle_outline_rounded,
                          //             //   color: Colors.white,
                          //             //   size: 50,
                          //             // ),
                          //             ),
                          //         SizedBox(
                          //           height: 25,
                          //         ),
                          //         Align(
                          //           alignment: Alignment.bottomCenter,
                          //           child: Text(
                          //             data['title'],
                          //             textAlign: TextAlign.center,
                          //             style: Theme.of(context)
                          //                 .textTheme
                          //                 .titleLarge
                          //                 .merge(TextStyle(
                          //                     color: Colors.white)),
                          //           ),
                          //         )
                          //       ],
                          //     ),
                          //   ],
                          // ),
                        ),
                      );
                    },
                  ),
                );
        },
      ),
    );
  }

  Widget _offsetPopup() => PopupMenuButton<int>(
    itemBuilder: (context) => [
      PopupMenuItem(
        onTap: () {
          //         showDialog(
          // context: context,
          // builder: (context) {
          //   return Dialog(
          //     child: Container(
          //       height: 100,
          //       width: 100,
          //       child: Center(child: CircularProgressIndicator()),
          //     ),
          //   );
          // });
        },
        value: 1,
        child: Wrap(
          children: [
            Icon(Icons.share),
            SizedBox(width: 10),
            Text(
              "Go to player",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      PopupMenuItem(
        value: 2,
        child: Wrap(
          children: [
            Icon(Icons.download),
            SizedBox(width: 10),
            Text(
              "Share",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    ],
    icon: Icon(Icons.more_vert, color: Colors.white),
  );

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
            SizedBox(height: 10),
            TextFormField(
              cursorColor: Colors.purple,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.amber),
                label: Text('Playlist  Name'),
              ),
              controller: textEditingController,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel', style: TextStyle(color: Colors.amber)),
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
                    .add({
                      'createdAt': FieldValue.serverTimestamp(),
                      'name': textEditingController.text,
                      'audios': [],
                    })
                    .then(
                      (value1) => FirebaseFirestore.instance
                          .collection('Devices')
                          .doc(deviceid)
                          .set({
                            'device': device,
                            'brand': brand,
                            'hardware': hardware,
                            'manufacturer': manufacturer,
                          }, SetOptions(merge: true)),
                    );

                Navigator.pop(context);
                Fluttertoast.showToast(msg: 'Playlist Created');
              } else {
                Fluttertoast.showToast(msg: 'Please enter playlist name');
              }
            },
            child: Text('Create', style: TextStyle(color: Colors.amber)),
          ),
        ],
      ),
    );
  }
}
