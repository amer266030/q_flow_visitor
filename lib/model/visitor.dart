class Visitor {
  String? id; // References user_id
  String? gender;
  int? experience;
  String? dob;
  String? resumeUrl;
  String? avatarUrl;

  Visitor({
    this.id,
    this.gender,
    this.experience,
    this.resumeUrl,
    this.avatarUrl,
  });

  factory Visitor.fromJson(Map<String, dynamic> json) {
    return Visitor(
      id: json['id'] as String?,
      gender: json['gender'] as String?,
      experience: json['experience'] as int?,
      resumeUrl: json['resumeUrl'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gender': gender,
      'experience': experience,
      'resumeUrl': resumeUrl,
      'avatarUrl': avatarUrl,
    };
  }
}
