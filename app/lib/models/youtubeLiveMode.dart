class YoutubeLiveModel {
  final String publishedAt;
  final String channelId;
  final String title;
  final String description;
  final String publishTime;
  final String channnelTitle;
  final String liveBroadcastContent;
  final Thumbnails thumbnails;
  final VideoDetails id;
  YoutubeLiveModel({
    required this.id,
    required this.publishedAt,
    required this.channelId,
    required this.title,
    required this.description,
    required this.publishTime,
    required this.channnelTitle,
    required this.liveBroadcastContent,
    required this.thumbnails,
  });

  factory YoutubeLiveModel.fromJson(Map<String, dynamic> json) {
    return YoutubeLiveModel(
        publishedAt: json['publishedAt'],
        channelId: json['channelId'],
        title: json['title'],
        description: json['description'],
        channnelTitle: json['channnelTitle'],
        liveBroadcastContent: json['liveBroadcastContent'],
        publishTime: json['publishTime'],
        thumbnails: json['thumbnails'],
        id: json['id']);
  }
}

class Thumbnails {
  final DefaultThumbnail defaults;
  final MediumThumbnail medium;
  final HighThumbnail high;

  Thumbnails(
      {required this.defaults, required this.medium, required this.high});
  factory Thumbnails.fromJson(Map<String, dynamic> json) {
    return Thumbnails(
        defaults: json['defaults'], medium: json['medium'], high: json['high']);
  }
}

class HighThumbnail {
  final String url;
  final int width;
  final int height;

  HighThumbnail({required this.url, required this.width, required this.height});

  factory HighThumbnail.fromJson(Map<String, dynamic> json) {
    return HighThumbnail(
        url: json['url'], width: json['width'], height: json['height']);
  }
}

class MediumThumbnail {
  final String url;
  final int width;
  final int height;

  MediumThumbnail(
      {required this.url, required this.width, required this.height});

  factory MediumThumbnail.fromJson(Map<String, dynamic> json) {
    return MediumThumbnail(
        url: json['url'], width: json['width'], height: json['height']);
  }
}

class DefaultThumbnail {
  final String url;
  final int width;
  final int height;

  DefaultThumbnail(
      {required this.url, required this.width, required this.height});

  factory DefaultThumbnail.fromJson(Map<String, dynamic> json) {
    return DefaultThumbnail(
        url: json['url'], width: json['width'], height: json['height']);
  }
}

class VideoDetails {
  final String kind;
  final String videoId;

  VideoDetails({
    required this.kind,
    required this.videoId,
  });

  factory VideoDetails.fromJson(Map<String, dynamic> json) {
    return VideoDetails(kind: json['kind'], videoId: json['videoId']);
  }
}
