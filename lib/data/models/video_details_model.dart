class VideoDetailsModel {
    final Videos? videos;

    VideoDetailsModel({
        this.videos,
    });

    VideoDetailsModel copyWith({
        Videos? videos,
    }) => 
        VideoDetailsModel(
            videos: videos ?? this.videos,
        );

    factory VideoDetailsModel.fromJson(Map<String, dynamic> json) => VideoDetailsModel(
        videos: json["videos"] == null ? null : Videos.fromJson(json["videos"]),
    );

    Map<String, dynamic> toJson() => {
        "videos": videos?.toJson(),
    };
}

class Videos {
    final String? title;
    final List<Video>? videos;

    Videos({
        this.title,
        this.videos,
    });

    Videos copyWith({
        String? title,
        List<Video>? videos,
    }) => 
        Videos(
            title: title ?? this.title,
            videos: videos ?? this.videos,
        );

    factory Videos.fromJson(Map<String, dynamic> json) => Videos(
        title: json["title"],
        videos: json["videos"] == null ? [] : List<Video>.from(json["videos"]!.map((x) => Video.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "videos": videos == null ? [] : List<dynamic>.from(videos!.map((x) => x.toJson())),
    };
}

class Video {
    final int? id;
    final String? title;
    final String? description;
    final String? status;
    final String? icon;
    final String? videoUrl;
    final bool? hasPlayButton;

    Video({
        this.id,
        this.title,
        this.description,
        this.status,
        this.icon,
        this.videoUrl,
        this.hasPlayButton,
    });

    Video copyWith({
        int? id,
        String? title,
        String? description,
        String? status,
        String? icon,
        String? videoUrl,
        bool? hasPlayButton,
    }) => 
        Video(
            id: id ?? this.id,
            title: title ?? this.title,
            description: description ?? this.description,
            status: status ?? this.status,
            icon: icon ?? this.icon,
            videoUrl: videoUrl ?? this.videoUrl,
            hasPlayButton: hasPlayButton ?? this.hasPlayButton,
        );

    factory Video.fromJson(Map<String, dynamic> json) => Video(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        status: json["status"],
        icon: json["icon"],
        videoUrl: json["video_url"],
        hasPlayButton: json["has_play_button"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "status": status,
        "icon": icon,
        "video_url": videoUrl,
        "has_play_button": hasPlayButton,
    };
}
