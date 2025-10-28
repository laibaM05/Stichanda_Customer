class CustomerModel {
  final String? id;
  final String username;
  final String password;
  final String? name;
  final String? phoneNumber;
  final String? email;
  final String? address;
  final String? gender; // 'Male', 'Female', 'Other'
  final String? profilePicUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CustomerModel({
    this.id,
    required this.username,
    required this.password,
    this.name,
    this.phoneNumber,
    this.email,
    this.address,
    this.gender,
    this.profilePicUrl,
    this.createdAt,
    this.updatedAt,
  });

  // Get initials for avatar
  String get initials {
    if (name != null && name!.isNotEmpty) {
      final parts = name!.trim().split(' ');
      if (parts.isEmpty) return username.substring(0, 1).toUpperCase();
      if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return username.substring(0, 1).toUpperCase();
  }

  // Convert from JSON
  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'],
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      address: json['address'],
      gender: json['gender'],
      profilePicUrl: json['profilePicUrl'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
      'gender': gender,
      'profilePicUrl': profilePicUrl,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Create copy with updated fields
  CustomerModel copyWith({
    String? id,
    String? username,
    String? password,
    String? name,
    String? phoneNumber,
    String? email,
    String? address,
    String? gender,
    String? profilePicUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'CustomerModel(id: $id, username: $username, name: $name, email: $email)';
  }
}
