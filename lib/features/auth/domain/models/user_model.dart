enum AuthMethod { google, phone, email }

class UserModel {
  final String uid;
  final String fullName;
  final String? email;
  final String? phone;
  final AuthMethod authMethod;
  final int credits;
  final DateTime? createdAt;

  const UserModel({
    required this.uid,
    required this.fullName,
    this.email,
    this.phone,
    required this.authMethod,
    this.credits = 3,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      'authMethod': authMethod.name,
      'credits': credits,
    };
  }
}
