class StreakModel {
    final int? currentDay;
    final int? totalDays;
    final List<Day>? days;

    StreakModel({
        this.currentDay,
        this.totalDays,
        this.days,
    });

    StreakModel copyWith({
        int? currentDay,
        int? totalDays,
        List<Day>? days,
    }) => 
        StreakModel(
            currentDay: currentDay ?? this.currentDay,
            totalDays: totalDays ?? this.totalDays,
            days: days ?? this.days,
        );

    factory StreakModel.fromJson(Map<String, dynamic> json) => StreakModel(
        currentDay: json["current_day"],
        totalDays: json["total_days"],
        days: json["days"] == null ? [] : List<Day>.from(json["days"]!.map((x) => Day.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "current_day": currentDay,
        "total_days": totalDays,
        "days": days == null ? [] : List<dynamic>.from(days!.map((x) => x.toJson())),
    };
}

class Day {
    final int? id;
    final int? dayNumber;
    final String? label;
    final bool? isCompleted;
    final bool? isCurrent;
    final Topic? topic;

    Day({
        this.id,
        this.dayNumber,
        this.label,
        this.isCompleted,
        this.isCurrent,
        this.topic,
    });

    Day copyWith({
        int? id,
        int? dayNumber,
        String? label,
        bool? isCompleted,
        bool? isCurrent,
        Topic? topic,
    }) => 
        Day(
            id: id ?? this.id,
            dayNumber: dayNumber ?? this.dayNumber,
            label: label ?? this.label,
            isCompleted: isCompleted ?? this.isCompleted,
            isCurrent: isCurrent ?? this.isCurrent,
            topic: topic ?? this.topic,
        );

    factory Day.fromJson(Map<String, dynamic> json) => Day(
        id: json["id"],
        dayNumber: json["day_number"],
        label: json["label"],
        isCompleted: json["is_completed"],
        isCurrent: json["is_current"],
        topic: json["topic"] == null ? null : Topic.fromJson(json["topic"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "day_number": dayNumber,
        "label": label,
        "is_completed": isCompleted,
        "is_current": isCurrent,
        "topic": topic?.toJson(),
    };
}

class Topic {
    final String? title;
    final List<Module>? modules;

    Topic({
        this.title,
        this.modules,
    });

    Topic copyWith({
        String? title,
        List<Module>? modules,
    }) => 
        Topic(
            title: title ?? this.title,
            modules: modules ?? this.modules,
        );

    factory Topic.fromJson(Map<String, dynamic> json) => Topic(
        title: json["title"],
        modules: json["modules"] == null ? [] : List<Module>.from(json["modules"]!.map((x) => Module.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "modules": modules == null ? [] : List<dynamic>.from(modules!.map((x) => x.toJson())),
    };
}

class Module {
    final Description? name;
    final Description? description;

    Module({
        this.name,
        this.description,
    });

    Module copyWith({
        Description? name,
        Description? description,
    }) => 
        Module(
            name: name ?? this.name,
            description: description ?? this.description,
        );

    factory Module.fromJson(Map<String, dynamic> json) => Module(
        name: descriptionValues.map[json["name"]]!,
        description: descriptionValues.map[json["description"]]!,
    );

    Map<String, dynamic> toJson() => {
        "name": descriptionValues.reverse[name],
        "description": descriptionValues.reverse[description],
    };
}

enum Description {
    ADVANCED_MODULE,
    CORE_MODULE
}

final descriptionValues = EnumValues({
    "Advanced Module": Description.ADVANCED_MODULE,
    "Core Module": Description.CORE_MODULE
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
