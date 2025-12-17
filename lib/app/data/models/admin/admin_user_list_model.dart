class AdminUserListResponse {
  List<AdminUserItem>? data;
  AdminPagination? pagination;

  AdminUserListResponse({this.data, this.pagination});

  factory AdminUserListResponse.fromJson(Map<String, dynamic> json) {
    return AdminUserListResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => AdminUserItem.fromJson(e))
          .toList(),
      pagination: json['pagination'] != null
          ? AdminPagination.fromJson(json['pagination'])
          : null,
    );
  }
}

class AdminUserItem {
  int? id;
  String? name;
  String? avatar;
  String? phone;
  String? email;
  int? isActive;
  String? lastLogin;
  String? createdAt;
  String? totalOrders;
  int? totalSales;
  List<AdminUserRoleWrapper>? role;

  AdminUserItem({
    this.id,
    this.name,
    this.avatar,
    this.phone,
    this.email,
    this.isActive,
    this.lastLogin,
    this.createdAt,
    this.totalOrders,
    this.totalSales,
    this.role,
  });

  factory AdminUserItem.fromJson(Map<String, dynamic> json) {
    return AdminUserItem(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      phone: json['phone'],
      email: json['email'],
      isActive: json['is_active'],
      lastLogin: json['last_login'],
      createdAt: json['created_at'],
      totalOrders: json['totalOrders']?.toString(),
      totalSales: json['totalSales'] is int ? json['totalSales'] : int.tryParse('${json['totalSales']}'),
      role: (json['role'] as List<dynamic>?)
          ?.map((e) => AdminUserRoleWrapper.fromJson(e))
          .toList(),
    );
  }

  String get primaryRoleName {
    final r = role;
    if (r == null || r.isEmpty) return '-';
    return r.first.role?.name ?? '-';
  }

  bool get active => (isActive ?? 0) == 1;
}

class AdminUserRoleWrapper {
  int? id;
  int? roleId;
  AdminRoleSimple? role;

  AdminUserRoleWrapper({this.id, this.roleId, this.role});

  factory AdminUserRoleWrapper.fromJson(Map<String, dynamic> json) {
    return AdminUserRoleWrapper(
      id: json['id'],
      roleId: json['role_id'],
      role: json['role'] != null ? AdminRoleSimple.fromJson(json['role']) : null,
    );
  }
}

class AdminRoleSimple {
  int? id;
  String? name;

  AdminRoleSimple({this.id, this.name});

  factory AdminRoleSimple.fromJson(Map<String, dynamic> json) {
    return AdminRoleSimple(
      id: json['id'],
      name: json['name'],
    );
  }
}

class AdminPagination {
  int? page;
  int? limit;
  int? totalPage;
  int? total;

  AdminPagination({this.page, this.limit, this.totalPage, this.total});

  factory AdminPagination.fromJson(Map<String, dynamic> json) {
    return AdminPagination(
      page: json['page'],
      limit: json['limit'],
      totalPage: json['totalPage'],
      total: json['total'],
    );
  }
}
