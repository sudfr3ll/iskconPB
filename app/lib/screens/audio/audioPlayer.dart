import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class AudioFile {
  final String title;
  final String description;
  final String url;
  int playingstatus;
  AudioFile(
      {required this.title,
      required this.description,
      required this.url,
      this.playingstatus = 0});
}

class MyAudioPlayer extends StatefulWidget {
  final String title;
  final String chapter;
  final String audioLink;
  final String imageLink;
  final dynamic data;
  const MyAudioPlayer(
      {super.key,
      required this.title,
      required this.audioLink,
      required this.imageLink,
      required this.chapter,
      this.data});

  @override
  State<MyAudioPlayer> createState() => _MyAudioPlayerState();
}

class _MyAudioPlayerState extends State<MyAudioPlayer> {
  /// For clarity, I added the terms compulsory and optional to certain sections
  /// to maintain clarity as to what is really needed for a functioning audio player
  /// and what is added for further interaction.
  ///
  /// 'Compulsory': A functioning audio player with:
  ///             - Play/Pause button
  ///
  /// 'Optional': A functioning audio player with:
  ///             - Play/Pause button
  ///             - time stamps for progress and duration
  ///             - slider to jump within the audio file
  ///
  /// Compulsory
  AudioPlayer audioPlayer = AudioPlayer();
  PlayerState audioPlayerState = PlayerState.paused;
  String? url;
  int? result;
  int status = 0;
  String? title;
  String? image;
  AudioCache? audioCache;

  /// Optional
  int timeProgress = 0;
  int audioDuration = 0;
  List audios = [];
  void generateAudioList() {}

  /// Optional
  Widget slider() {
    return SizedBox(
      child: Slider.adaptive(
          mouseCursor: MouseCursor.defer,
          activeColor: Colors.white,
          inactiveColor: Color.fromARGB(255, 152, 76, 211),
          value: timeProgress.toDouble(),
          max: audioDuration.toDouble(),
          onChanged: (value) {
            seekToSec(value.toInt());
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    generateAudioList();
    setState(() {
      title = widget.title;
      url = widget.audioLink;
      image = widget.imageLink;
    });

    /// Compulsory
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        audioPlayerState = state;
      });
    });

    /// Optional
    audioPlayer.setSource(UrlSource(
        url!)); // Triggers the onDurationChanged listener and sets the max duration string
    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        audioDuration = duration.inSeconds;
      });
    });
    audioPlayer.onPositionChanged.listen((Duration position) async {
      setState(() {
        timeProgress = position.inSeconds;
      });
    });
    playMusic();
  }

  /// Compulsory
  @override
  void dispose() {
    audioPlayer.release();
    audioPlayer.dispose();
    super.dispose();
  }

  /// Compulsory
  Future<void> playMusic() async {
    // Add the parameter "isLocal: true" if you want to access a local file
    await audioPlayer.play(
      UrlSource(url!),
    );
  }

  /// Compulsory
  Future<void> pauseMusic() async {
    await audioPlayer.pause();
  }

  /// Optional
  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    audioPlayer
        .seek(newPos); // Jumps to the given position within the audio file
  }

  void fastforward(Duration sec) {}

  /// Optional
  String getTimeString(int seconds) {
    String minuteString =
        '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
    String secondString = '${seconds % 60 < 10 ? 0 : ''}${seconds % 60}';
    return '$minuteString:$secondString'; // Returns a string with the format mm:ss
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(widget.chapter)),
      body: Container(
          color: Color.fromRGBO(112, 5, 195, 1),
          child: Column(
            children: [
              /// Compulsory
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  image!,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              widget.title.length < 20
                  ? Text(
                      title!,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .merge(TextStyle(color: Colors.white)),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SizedBox(
                        height: 100,
                        child: Marquee(
                          text: title!,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .merge(TextStyle(color: Colors.white)),
                          blankSpace: 40,
                          scrollAxis: Axis.horizontal,
                        ),
                      ),
                    ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width, child: slider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Text(
                      getTimeString(timeProgress),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    Text(
                      getTimeString(audioDuration),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.repeat_one_rounded,
                          color: Colors.white,
                        )),
                    IconButton(
                        onPressed: () async {
                          // seekToSec(-10);
                        },
                        icon: Icon(
                          Icons.skip_previous,
                          color: Colors.white,
                        )),
                    InkWell(
                      onTap: () {
                        audioPlayerState == PlayerState.playing
                            ? pauseMusic()
                            : playMusic();
                      },
                      child: Container(
                          height: 100,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 152, 76, 211),
                          ),
                          child: Icon(
                            audioPlayerState == PlayerState.playing
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 40,
                          )),
                    ),
                    // IconButton(
                    //     color: Colors.green,
                    //     iconSize: 50,
                    //     onPressed: () {
                    //       audioPlayerState == PlayerState.PLAYING
                    //           ? pauseMusic()
                    //           : playMusic();
                    //     },
                    //     icon: Icon(audioPlayerState == PlayerState.PLAYING
                    //         ? Icons.pause_rounded
                    //         : Icons.play_arrow_rounded)),
                    IconButton(
                        onPressed: () {
                          // seekToSec(10);
                        },
                        icon: Icon(
                          Icons.skip_next,
                          color: Colors.white,
                        )),
                    IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                              backgroundColor: Color.fromRGBO(112, 5, 195, 1),
                              context: context,
                              builder: (context) => Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.drag_handle,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                      ListView.separated(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: widget.data.length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ListTile(
                                                  onTap: () {
                                                    setState(() {
                                                      url = widget.data[index]
                                                          ['url'];
                                                      title = widget.data[index]
                                                          ['title'];
                                                      image = widget.data[index]
                                                          ['coverImage'];
                                                      playMusic();
                                                      Navigator.pop(context);
                                                    });
                                                    print(title);
                                                  },
                                                  leading: Image.network(
                                                    widget.data[index]
                                                        ['coverImage'],
                                                    width: 50,
                                                    height: 50,
                                                  ),
                                                  title: widget
                                                              .data[index]
                                                                  ['title']
                                                              .length <
                                                          20
                                                      ? Text(
                                                          widget.data[index]
                                                              ['title'],
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .titleLarge!
                                                              .merge(TextStyle(
                                                                  color: Colors
                                                                      .white)))
                                                      : SizedBox(
                                                          height: 50,
                                                          child: Marquee(
                                                            text: widget
                                                                    .data[index]
                                                                ['title'],
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleLarge!
                                                                .merge(TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                            blankSpace: 40,
                                                            scrollAxis:
                                                                Axis.horizontal,
                                                          ),
                                                        ),
                                                  // Text(
                                                  //  ,
                                                  //   style: TextStyle(
                                                  //       color: Colors.white),
                                                  // ),
                                                  trailing: Container(
                                                      height: 30,
                                                      width: 30,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Color.fromARGB(
                                                            255, 152, 76, 211),
                                                      ),
                                                      child: Icon(
                                                        Icons
                                                            .play_arrow_rounded,
                                                        color: Colors.white,
                                                        size: 15,
                                                      )),
                                                  subtitle: Text(
                                                    widget.data[index]
                                                        ['chapter'],
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return Divider(
                                            color: Colors.white,
                                          );
                                        },
                                      ),
                                    ],
                                  ));
                        },
                        icon: Icon(
                          Icons.list,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
