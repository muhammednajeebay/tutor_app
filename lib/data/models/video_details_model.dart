class VideoDetailsModel {
  final int? status;
  final String? message;
  final Data? data;

  VideoDetailsModel({this.status, this.message, this.data});

  VideoDetailsModel copyWith({int? status, String? message, Data? data}) =>
      VideoDetailsModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory VideoDetailsModel.fromJson(Map<String, dynamic> json) =>
      VideoDetailsModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };

  void operator []=(int other, Video value) {}
}

class Data {
  final String? title;
  final List<Video>? videos;

  Data({this.title, this.videos});

  Data copyWith({String? title, List<Video>? videos}) =>
      Data(title: title ?? this.title, videos: videos ?? this.videos);

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    title: json["title"],
    videos: json["videos"] == null
        ? []
        : List<Video>.from(json["videos"]!.map((x) => Video.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "videos": videos == null
        ? []
        : List<dynamic>.from(videos!.map((x) => x.toJson())),
  };
}

class Video {
  final int? id;
  final String? title;
  final String? description;
  String? status;
  final String? videoUrl;
  final int? totalDuration;
  final int? watchedDuration;
  final int? progressPercentage;
  final bool? hasPlayButton;

  Video({
    this.id,
    this.title,
    this.description,
    this.status,
    this.videoUrl,
    this.totalDuration,
    this.watchedDuration,
    this.progressPercentage,
    this.hasPlayButton,
  });

  Video copyWith({
    int? id,
    String? title,
    String? description,
    String? status,
    String? videoUrl,
    int? totalDuration,
    int? watchedDuration,
    int? progressPercentage,
    bool? hasPlayButton,
  }) => Video(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    status: status ?? this.status,
    videoUrl: videoUrl ?? this.videoUrl,
    totalDuration: totalDuration ?? this.totalDuration,
    watchedDuration: watchedDuration ?? this.watchedDuration,
    progressPercentage: progressPercentage ?? this.progressPercentage,
    hasPlayButton: hasPlayButton ?? this.hasPlayButton,
  );

  factory Video.fromJson(Map<String, dynamic> json) => Video(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    status: json["status"],
    videoUrl: json["video_url"],
    totalDuration: json["total_duration"],
    watchedDuration: json["watched_duration"],
    progressPercentage: json["progress_percentage"],
    hasPlayButton: json["has_play_button"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "status": status,
    "video_url": videoUrl,
    "total_duration": totalDuration,
    "watched_duration": watchedDuration,
    "progress_percentage": progressPercentage,
    "has_play_button": hasPlayButton,
  };
}
