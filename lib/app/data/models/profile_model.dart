// profile_model.dart

class Profile {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? avatar;
  String? dob;

  Profile({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.avatar,
    this.dob,
  });

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    avatar = json['avatar'];
    dob = json['dob'];
  }
}
