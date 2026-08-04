import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iskcon/constants/databaseService.dart';
import 'package:iskcon/constants/provider.dart';
import 'package:iskcon/screens/Donate/donate_by_paytm.dart';
import 'package:iskcon/widgets/customAppBar.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayer extends StatefulWidget {
  final String youtubeId;

  const VideoPlayer({
    super.key,
    required this.youtubeId,
  });

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  String? liveTitle;
  String? youtubeId;

  bool isLoading = true;
  bool isReady = false;

  final String videoUrl = "https://www.youtube.com/watch?v=";

  List<Map<String, dynamic>> timings = [];

  late YoutubePlayerController _youtubePlayerController;

  Future<void> youtubePlayer() async {
    var provider = Provider.of<AppState>(
      context,
      listen: false,
    );

    DocumentSnapshot documentSnapshot = await DataBaseSerice().liveStream();

    youtubeId = widget.youtubeId.isNotEmpty ? widget.youtubeId : provider.ytUrl;

    liveTitle = documentSnapshot.get('title');

    List timeData = documentSnapshot.get('timings');

    for (var item in timeData) {
      timings.add({
        "start": item['start'],
        "end": item['end'],
      });
    }

    final videoId = YoutubePlayerController.convertUrlToId(
      videoUrl + youtubeId!,
    );

    _youtubePlayerController = YoutubePlayerController.fromVideoId(
      videoId: videoId ?? "",
      autoPlay: true,
      params: YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        mute: false,
        loop: false,
        enableCaption: true,
      ),
    );

    if (mounted) {
      setState(() {
        isReady = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    Provider.of<AppState>(
      context,
      listen: false,
    ).callFunction();

    youtubePlayer();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _youtubePlayerController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isReady == false) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: CustomAppBar(
            title: "LIVE BROADCAST",
          ),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Colors.purple,
              ),
              SizedBox(height: 4),
              Text("Loading..."),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: CustomAppBar(
          title: "LIVE BROADCAST",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: YoutubePlayer(
                controller: _youtubePlayerController,
              ),
            ),
            const SizedBox(height: 10),
            isLoading
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("Loading..."),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          liveTitle ?? "",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Connect with us through live broadcasting of temple hall",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Timings:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: timings.map((i) {
                            return Text(
                              "${i['start']} - ${i['end']}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "You can also tune in our channel on Youtube",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          width: 120,
                          decoration: BoxDecoration(
                            color: const Color(0xff9C5AB1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => DonateByPaytm(
                                    donId: "Live",
                                    donName: "Live",
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.account_balance_wallet,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "DONATE",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
