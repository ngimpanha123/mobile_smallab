class Profile {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? avatar;
  String? createdAt;
  List<Role>? roles;

  Profile({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.avatar,
    this.createdAt,
    this.roles,
  });

  Profile.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    phone = json["phone"];
    email = json["email"];
    avatar = json["avatar"];
    createdAt = json["created_at"];

    if (json["roles"] != null) {
      roles = (json["roles"] as List)
          .map((role) => Role.fromJson(role))
          .toList();
    }
  }
}

// ======================= ROLE MODEL =======================

class Role {
  int? id;
  String? name;
  String? slug;
  Map<String, dynamic>? userRoles;

  Role({
    this.id,
    this.name,
    this.slug,
    this.userRoles,
  });

  Role.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    slug = json["slug"];
    userRoles = json["UserRoles"];
  }
}
