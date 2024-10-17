class Company {
  String? id; // References user_id
  String? description;
  int? numEmployees;
  int? establishedYear;
  String? logoUrl;

  Company({
    this.id,
    this.description,
    this.numEmployees,
    this.establishedYear,
    this.logoUrl,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'] as String?,
      description: json['description'] as String?,
      numEmployees: json['numEmployees'] as int?,
      establishedYear: json['establishedYear'] as int?,
      logoUrl: json['logoUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'numEmployees': numEmployees,
      'establishedYear': establishedYear,
      'logoUrl': logoUrl,
    };
  }
}
