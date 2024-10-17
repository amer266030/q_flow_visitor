class User {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? role;
  String? password;
  String? createdAt;
  String? externalId;

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.role,
    this.password,
    this.createdAt,
    this.externalId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      role: json['role'] as String?,
      createdAt: json['created_at'] as String?,
      externalId: json['external_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'created_at': createdAt,
      'external_id': externalId,
    };
  }
}
