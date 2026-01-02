class HomeModel {
  final User? user;
  final List<HeroBanner>? heroBanners;
  final ActiveCourse? activeCourse;
  final List<PopularCourse>? popularCourses;
  final LiveSession? liveSession;
  final Community? community;
  final List<Testimonial>? testimonials;
  final Support? support;

  HomeModel({
    this.user,
    this.heroBanners,
    this.activeCourse,
    this.popularCourses,
    this.liveSession,
    this.community,
    this.testimonials,
    this.support,
  });

  HomeModel copyWith({
    User? user,
    List<HeroBanner>? heroBanners,
    ActiveCourse? activeCourse,
    List<PopularCourse>? popularCourses,
    LiveSession? liveSession,
    Community? community,
    List<Testimonial>? testimonials,
    Support? support,
  }) => HomeModel(
    user: user ?? this.user,
    heroBanners: heroBanners ?? this.heroBanners,
    activeCourse: activeCourse ?? this.activeCourse,
    popularCourses: popularCourses ?? this.popularCourses,
    liveSession: liveSession ?? this.liveSession,
    community: community ?? this.community,
    testimonials: testimonials ?? this.testimonials,
    support: support ?? this.support,
  );

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    heroBanners: json["hero_banners"] == null
        ? []
        : List<HeroBanner>.from(
            json["hero_banners"]!.map((x) => HeroBanner.fromJson(x)),
          ),
    activeCourse: json["active_course"] == null
        ? null
        : ActiveCourse.fromJson(json["active_course"]),
    popularCourses: json["popular_courses"] == null
        ? []
        : List<PopularCourse>.from(
            json["popular_courses"]!.map((x) => PopularCourse.fromJson(x)),
          ),
    liveSession: json["live_session"] == null
        ? null
        : LiveSession.fromJson(json["live_session"]),
    community: json["community"] == null
        ? null
        : Community.fromJson(json["community"]),
    testimonials: json["testimonials"] == null
        ? []
        : List<Testimonial>.from(
            json["testimonials"]!.map((x) => Testimonial.fromJson(x)),
          ),
    support: json["support"] == null ? null : Support.fromJson(json["support"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "hero_banners": heroBanners == null
        ? []
        : List<dynamic>.from(heroBanners!.map((x) => x.toJson())),
    "active_course": activeCourse?.toJson(),
    "popular_courses": popularCourses == null
        ? []
        : List<dynamic>.from(popularCourses!.map((x) => x.toJson())),
    "live_session": liveSession?.toJson(),
    "community": community?.toJson(),
    "testimonials": testimonials == null
        ? []
        : List<dynamic>.from(testimonials!.map((x) => x.toJson())),
    "support": support?.toJson(),
  };
}

class ActiveCourse {
  final int? id;
  final String? title;
  final int? progress;
  final int? testsCompleted;
  final int? totalTests;

  ActiveCourse({
    this.id,
    this.title,
    this.progress,
    this.testsCompleted,
    this.totalTests,
  });

  ActiveCourse copyWith({
    int? id,
    String? title,
    int? progress,
    int? testsCompleted,
    int? totalTests,
  }) => ActiveCourse(
    id: id ?? this.id,
    title: title ?? this.title,
    progress: progress ?? this.progress,
    testsCompleted: testsCompleted ?? this.testsCompleted,
    totalTests: totalTests ?? this.totalTests,
  );

  factory ActiveCourse.fromJson(Map<String, dynamic> json) => ActiveCourse(
    id: json["id"],
    title: json["title"],
    progress: json["progress"],
    testsCompleted: json["tests_completed"],
    totalTests: json["total_tests"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "progress": progress,
    "tests_completed": testsCompleted,
    "total_tests": totalTests,
  };
}

class Community {
  final int? id;
  final String? name;
  final int? activeMembers;
  final String? description;
  final RecentActivity? recentActivity;
  final String? action;

  Community({
    this.id,
    this.name,
    this.activeMembers,
    this.description,
    this.recentActivity,
    this.action,
  });

  Community copyWith({
    int? id,
    String? name,
    int? activeMembers,
    String? description,
    RecentActivity? recentActivity,
    String? action,
  }) => Community(
    id: id ?? this.id,
    name: name ?? this.name,
    activeMembers: activeMembers ?? this.activeMembers,
    description: description ?? this.description,
    recentActivity: recentActivity ?? this.recentActivity,
    action: action ?? this.action,
  );

  factory Community.fromJson(Map<String, dynamic> json) => Community(
    id: json["id"],
    name: json["name"],
    activeMembers: json["active_members"],
    description: json["description"],
    recentActivity: json["recent_activity"] == null
        ? null
        : RecentActivity.fromJson(json["recent_activity"]),
    action: json["action"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "active_members": activeMembers,
    "description": description,
    "recent_activity": recentActivity?.toJson(),
    "action": action,
  };
}

class RecentActivity {
  final int? recentPosts;
  final String? status;
  final List<RecentMember>? recentMembers;

  RecentActivity({this.recentPosts, this.status, this.recentMembers});

  RecentActivity copyWith({
    int? recentPosts,
    String? status,
    List<RecentMember>? recentMembers,
  }) => RecentActivity(
    recentPosts: recentPosts ?? this.recentPosts,
    status: status ?? this.status,
    recentMembers: recentMembers ?? this.recentMembers,
  );

  factory RecentActivity.fromJson(Map<String, dynamic> json) => RecentActivity(
    recentPosts: json["recent_posts"],
    status: json["status"],
    recentMembers: json["recent_members"] == null
        ? []
        : List<RecentMember>.from(
            json["recent_members"]!.map((x) => RecentMember.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "recent_posts": recentPosts,
    "status": status,
    "recent_members": recentMembers == null
        ? []
        : List<dynamic>.from(recentMembers!.map((x) => x.toJson())),
  };
}

class RecentMember {
  final int? id;
  final String? avatar;

  RecentMember({this.id, this.avatar});

  RecentMember copyWith({int? id, String? avatar}) =>
      RecentMember(id: id ?? this.id, avatar: avatar ?? this.avatar);

  factory RecentMember.fromJson(Map<String, dynamic> json) =>
      RecentMember(id: json["id"], avatar: json["avatar"]);

  Map<String, dynamic> toJson() => {"id": id, "avatar": avatar};
}

class HeroBanner {
  final int? id;
  final String? title;
  final String? image;
  final bool? isActive;
  final String? action;

  HeroBanner({this.id, this.title, this.image, this.isActive, this.action});

  HeroBanner copyWith({
    int? id,
    String? title,
    String? image,
    bool? isActive,
    String? action,
  }) => HeroBanner(
    id: id ?? this.id,
    title: title ?? this.title,
    image: image ?? this.image,
    isActive: isActive ?? this.isActive,
    action: action ?? this.action,
  );

  factory HeroBanner.fromJson(Map<String, dynamic> json) => HeroBanner(
    id: json["id"],
    title: json["title"],
    image: json["image"],
    isActive: json["is_active"],
    action: json["action"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": image,
    "is_active": isActive,
    "action": action,
  };
}

class LiveSession {
  final int? id;
  final bool? isLive;
  final String? title;
  final Instructor? instructor;
  final SessionDetails? sessionDetails;
  final String? action;

  LiveSession({
    this.id,
    this.isLive,
    this.title,
    this.instructor,
    this.sessionDetails,
    this.action,
  });

  LiveSession copyWith({
    int? id,
    bool? isLive,
    String? title,
    Instructor? instructor,
    SessionDetails? sessionDetails,
    String? action,
  }) => LiveSession(
    id: id ?? this.id,
    isLive: isLive ?? this.isLive,
    title: title ?? this.title,
    instructor: instructor ?? this.instructor,
    sessionDetails: sessionDetails ?? this.sessionDetails,
    action: action ?? this.action,
  );

  factory LiveSession.fromJson(Map<String, dynamic> json) => LiveSession(
    id: json["id"],
    isLive: json["is_live"],
    title: json["title"],
    instructor: json["instructor"] == null
        ? null
        : Instructor.fromJson(json["instructor"]),
    sessionDetails: json["session_details"] == null
        ? null
        : SessionDetails.fromJson(json["session_details"]),
    action: json["action"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "is_live": isLive,
    "title": title,
    "instructor": instructor?.toJson(),
    "session_details": sessionDetails?.toJson(),
    "action": action,
  };
}

class Instructor {
  final String? name;

  Instructor({this.name});

  Instructor copyWith({String? name}) => Instructor(name: name ?? this.name);

  factory Instructor.fromJson(Map<String, dynamic> json) =>
      Instructor(name: json["name"]);

  Map<String, dynamic> toJson() => {"name": name};
}

class SessionDetails {
  final int? sessionNumber;
  final String? date;
  final String? time;

  SessionDetails({this.sessionNumber, this.date, this.time});

  SessionDetails copyWith({int? sessionNumber, String? date, String? time}) =>
      SessionDetails(
        sessionNumber: sessionNumber ?? this.sessionNumber,
        date: date ?? this.date,
        time: time ?? this.time,
      );

  factory SessionDetails.fromJson(Map<String, dynamic> json) => SessionDetails(
    sessionNumber: json["session_number"],
    date: json["date"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "session_number": sessionNumber,
    "date": date,
    "time": time,
  };
}

class PopularCourse {
  final int? id;
  final String? name;
  final List<HeroBanner>? courses;

  PopularCourse({this.id, this.name, this.courses});

  PopularCourse copyWith({int? id, String? name, List<HeroBanner>? courses}) =>
      PopularCourse(
        id: id ?? this.id,
        name: name ?? this.name,
        courses: courses ?? this.courses,
      );

  factory PopularCourse.fromJson(Map<String, dynamic> json) => PopularCourse(
    id: json["id"],
    name: json["name"],
    courses: json["courses"] == null
        ? []
        : List<HeroBanner>.from(
            json["courses"]!.map((x) => HeroBanner.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "courses": courses == null
        ? []
        : List<dynamic>.from(courses!.map((x) => x.toJson())),
  };
}

class Support {
  final String? title;
  final String? description;
  final String? exampleQuestion;
  final String? illustration;
  final List<Action>? actions;

  Support({
    this.title,
    this.description,
    this.exampleQuestion,
    this.illustration,
    this.actions,
  });

  Support copyWith({
    String? title,
    String? description,
    String? exampleQuestion,
    String? illustration,
    List<Action>? actions,
  }) => Support(
    title: title ?? this.title,
    description: description ?? this.description,
    exampleQuestion: exampleQuestion ?? this.exampleQuestion,
    illustration: illustration ?? this.illustration,
    actions: actions ?? this.actions,
  );

  factory Support.fromJson(Map<String, dynamic> json) => Support(
    title: json["title"],
    description: json["description"],
    exampleQuestion: json["example_question"],
    illustration: json["illustration"],
    actions: json["actions"] == null
        ? []
        : List<Action>.from(json["actions"]!.map((x) => Action.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "example_question": exampleQuestion,
    "illustration": illustration,
    "actions": actions == null
        ? []
        : List<dynamic>.from(actions!.map((x) => x.toJson())),
  };
}

class Action {
  final String? type;
  final String? label;
  final String? icon;

  Action({this.type, this.label, this.icon});

  Action copyWith({String? type, String? label, String? icon}) => Action(
    type: type ?? this.type,
    label: label ?? this.label,
    icon: icon ?? this.icon,
  );

  factory Action.fromJson(Map<String, dynamic> json) =>
      Action(type: json["type"], label: json["label"], icon: json["icon"]);

  Map<String, dynamic> toJson() => {"type": type, "label": label, "icon": icon};
}

class Testimonial {
  final int? id;
  final Learner? learner;
  final String? review;
  final bool? isActive;

  Testimonial({this.id, this.learner, this.review, this.isActive});

  Testimonial copyWith({
    int? id,
    Learner? learner,
    String? review,
    bool? isActive,
  }) => Testimonial(
    id: id ?? this.id,
    learner: learner ?? this.learner,
    review: review ?? this.review,
    isActive: isActive ?? this.isActive,
  );

  factory Testimonial.fromJson(Map<String, dynamic> json) => Testimonial(
    id: json["id"],
    learner: json["learner"] == null ? null : Learner.fromJson(json["learner"]),
    review: json["review"],
    isActive: json["is_active"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "learner": learner?.toJson(),
    "review": review,
    "is_active": isActive,
  };
}

class Learner {
  final String? name;
  final String? avatar;

  Learner({this.name, this.avatar});

  Learner copyWith({String? name, String? avatar}) =>
      Learner(name: name ?? this.name, avatar: avatar ?? this.avatar);

  factory Learner.fromJson(Map<String, dynamic> json) =>
      Learner(name: json["name"], avatar: json["avatar"]);

  Map<String, dynamic> toJson() => {"name": name, "avatar": avatar};
}

class User {
  final String? name;
  final String? greeting;
  final Streak? streak;

  User({this.name, this.greeting, this.streak});

  User copyWith({String? name, String? greeting, Streak? streak}) => User(
    name: name ?? this.name,
    greeting: greeting ?? this.greeting,
    streak: streak ?? this.streak,
  );

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["name"],
    greeting: json["greeting"],
    streak: json["streak"] == null ? null : Streak.fromJson(json["streak"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "greeting": greeting,
    "streak": streak?.toJson(),
  };
}

class Streak {
  final int? days;
  final String? icon;

  Streak({this.days, this.icon});

  Streak copyWith({int? days, String? icon}) =>
      Streak(days: days ?? this.days, icon: icon ?? this.icon);

  factory Streak.fromJson(Map<String, dynamic> json) =>
      Streak(days: json["days"], icon: json["icon"]);

  Map<String, dynamic> toJson() => {"days": days, "icon": icon};
}
