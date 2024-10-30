import '../enums/user_social_link.dart';

class SocialLink {
  String? id;
  String? userId;
  LinkType? linkType;
  String? url;

  SocialLink({this.id, this.userId, this.linkType, this.url});

  // Convert JSON to SocialLink object
  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,
      linkType: json['link_type'] != null
          ? LinkTypeExtension.fromString(json['link_type'] as String)
          : null,
      url: json['url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'link_type': linkType?.value,
      'url': url,
    };
  }
}
