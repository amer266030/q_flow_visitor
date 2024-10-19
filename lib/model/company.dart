import 'package:q_flow/model/enums/company_size.dart';

class Company {
  String? id; // References user_id
  String? name;
  String? description;
  CompanySize? companySize;
  int? establishedYear;
  String? logoUrl;

  Company({
    this.id,
    this.name,
    this.description,
    this.companySize,
    this.establishedYear,
    this.logoUrl,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      // Convert the string representation of company size into enum
      companySize: json['companySize'] != null
          ? CompanySizeExtension.fromString(json['companySize'] as String?)
          : null,
      establishedYear: json['establishedYear'] as int?,
      logoUrl: json['logoUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'companySize': companySize?.value,
      'establishedYear': establishedYear,
      'logoUrl': logoUrl,
    };
  }
}
