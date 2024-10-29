import '../enums/bootcamp.dart';
import '../enums/experience.dart';
import '../enums/gender.dart';

class Visitor {
  String? id; // References user_id
  Gender? gender;
  String? fName;
  String? lName;
  Experience? experience;
  String? dob;
  Bootcamp? bootcamp;
  String? resumeUrl;
  String? avatarUrl;

  Visitor({
    this.id,
    this.gender,
    this.fName,
    this.lName,
    this.experience,
    this.dob,
    this.bootcamp,
    this.resumeUrl,
    this.avatarUrl,
  });

  factory Visitor.fromJson(Map<String, dynamic> json) {
    return Visitor(
      id: json['id'] as String?,
      gender: json['gender'] != null
          ? GenderExtension.fromString(json['gender'] as String?)
          : null,
      fName: json['f_name'] as String?,
      lName: json['l_name'] as String?,
      experience: json['experience'] != null
          ? ExperienceExtension.fromString(json['experience'] as String?)
          : null,
      dob: json['dob'] as String?,
      bootcamp: json['bootcamp'] != null
          ? BootcampExtension.fromString(json['bootcamp'] as String?)
          : null,
      resumeUrl: json['resume_url'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gender': gender?.value,
      'f_name': fName,
      'l_name': lName,
      'experience': experience?.value,
      'dob': dob,
      'bootcamp': bootcamp?.value,
      'resume_url': resumeUrl,
      'avatar_url': avatarUrl,
    };
  }
}
