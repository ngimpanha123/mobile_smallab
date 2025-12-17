import 'admin_user_list_model.dart';

class AdminUserViewResponse {
  AdminUserItem? data;

  AdminUserViewResponse({this.data});

  factory AdminUserViewResponse.fromJson(Map<String, dynamic> json) {
    return AdminUserViewResponse(
      data: json['data'] != null ? AdminUserItem.fromJson(json['data']) : null,
    );
  }
}
