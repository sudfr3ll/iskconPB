// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:iskcon/models/urlLauncher.dart';
import 'package:iskcon/widgets/customAppBar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MyVideoPlayer extends StatefulWidget {
  final String videoLink;
  final String topTitle;
  final dynamic data;

  const MyVideoPlayer({
    super.key,
    required this.videoLink,
    required this.topTitle,
    this.data,
  });

  @override
  State<MyVideoPlayer> createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  String? videoUrl;
  String? title;

  bool isReady = false;

  late YoutubePlayerController _youtubePlayerController;

  void youtubePlayer() {
    videoUrl = 'https://www.youtube.com/watch?v=${widget.videoLink}';

    final videoId = YoutubePlayerController.convertUrlToId(videoUrl!);

    // SAME AS YOUR CODE - NOT CHANGED
    _youtubePlayerController = YoutubePlayerController.fromVideoId(
      videoId: videoId ?? "",
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        mute: false,
        loop: true,
        enableCaption: true,
      ),
    );

    setState(() {
      isReady = true;
    });
  }

  @override
  void initState() {
    super.initState();

    youtubePlayer();

    print(widget.videoLink);
  }

  @override
  void dispose() {
    _youtubePlayerController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isReady) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: CustomAppBar(
            title: widget.topTitle,
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
          title: widget.topTitle,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: YoutubePlayer(
              controller: _youtubePlayerController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.data['title'].toString().trim(),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        SharePlus.instance.share(
  ShareParams(
    text: videoUrl!,
  ),
);
                      },
                      child: const Column(
                        children: [
                          Icon(
                            Icons.redo_sharp,
                          ),
                          Text(
                            "Share",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  widget.data['description'].toString().trim(),
                ),
                const SizedBox(height: 4),
                Text(
                  "Find us on youtube:",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                InkWell(
                  onTap: () {
                    UrlLaunchers().urlLaunch(videoUrl);
                  },
                  child: Text(
                    videoUrl!,
                    style: const TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
