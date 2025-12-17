class AdminUserSetupResponse {
  List<AdminRole>? roles;

  AdminUserSetupResponse({this.roles});

  factory AdminUserSetupResponse.fromJson(Map<String, dynamic> json) {
    return AdminUserSetupResponse(
      roles: (json['roles'] as List<dynamic>?)
          ?.map((e) => AdminRole.fromJson(e))
          .toList(),
    );
  }
}

class AdminRole {
  int? id;
  String? name;

  AdminRole({this.id, this.name});

  factory AdminRole.fromJson(Map<String, dynamic> json) {
    return AdminRole(
      id: json['id'],
      name: json['name'],
    );
  }
}
